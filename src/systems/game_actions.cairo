use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use starknet::ContractAddress;

use dojomon::models::item::{Item};

#[dojo::interface]
trait IGameActions {
    fn catch(self: @TContractState, possible_rewards: Array<u16>, percentages: Array<u16>);

    fn get_items(player: ContractAddress) -> Array<Item>;
}

#[dojo::contract]
mod GameActions {
    use starknet::{get_caller_address};
    use dojomon::constants::{MAX_BLOCK_TIME, DEFAULT_INVENTORY_CAPACITY};
    use dojomon::store::{Store, StoreTrait};
    use dojomon::events::{Catched};
    use dojomon::models::user::{User};
    use dojomon::models::item::{Item};
    use dojomon::models::random::{Random};
    use dojomon::utils::{rotl, U64};
    use super::{ContractAddress, IGameActions};

    #[abi(embed_v0)]
    impl IGameActionsImpl of IGameActions<ContractState> {
        // Sum of all percentages = 10_000
        fn catch(self: @ContractState, possible_rewards: Array<u16>, percentages: Array<u16>) {
            let len = possible_rewards.len();
            assert(len == percentages.len(), 'length mismatch');
            
            let player = get_caller_address();
            let world = self.world_dispatcher.read();
            let mut store: Store = StoreTrait::new(world);

            let mut user = store.user(player);
            if (user.inventory_cap == 0) {
                user.inventory_cap = DEFAULT_INVENTORY_CAPACITY;
                store.set_user(user);
            }

            let random: u16 = (next_random(store) % 10_000).try_into().unwrap();
            let mut sum = 0_u16;
            let mut i = 0_u32;
            let mut selectedIdx = 0xffffffff_u32;
            
            loop {
                sum += *percentages.at(i);
                if (sum > random && selectedIdx == 0xffffffff_u32) {
                    selectedIdx = i;
                }

                i += 1;
                if (i >= len) {
                    break();
                }
            };
            assert(sum == 10_000, 'not 100%');
            let item_id = *possible_rewards.at(selectedIdx);
            assert(item_id < user.inventory_cap, 'invalid reward');
            if (item_id > 0) {
                // hit
                let mut item = store.item(player, item_id);
                item.amount += 1;

                store.set_item(item);
            } else {
                // miss
            }

            emit!(world, ( Catched { 
                player, 
                succeed: item_id > 0, 
                item_id: item_id
            } ));

        }

        fn get_items(player: ContractAddress) -> Array<Item> {
            let world = self.world_dispatcher.read();
            let store: Store = StoreTrait::new(world);

            store.items(player)
        }
    }


    fn next_random(store: Store) -> u128 {
        let mut random = store.random();
        let result = (rotl(random.s0 * 5, 7) * 9) & U64;

        random.s1 = (random.s1 ^ random.s0) & U64;
        
        random.s0 = (rotl(random.s0, 24) ^ random.s1 ^ (random.s1 * 65536)) & U64;
        random.s1 = (rotl(random.s1, 37) & U64);
        store.set_random(random);

        result
    }
}