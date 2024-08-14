//! Store struct and component management methods.

// Core imports
use core::debug::PrintTrait;

// Straknet imports
use starknet::ContractAddress;

// Dojo imports
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

// Models imports
use dojomon::models::user::{User};
use dojomon::models::item::{Item};
use dojomon::models::random::{Random};

/// Store struct.
#[derive(Copy, Drop)]
struct Store {
    world: IWorldDispatcher,
}

/// Implementation of the `StoreTrait` trait for the `Store` struct.
#[generate_trait]
impl StoreImpl of StoreTrait {
    #[inline(always)]
    fn new(world: IWorldDispatcher) -> Store {
        Store { world: world }
    }

    fn random(self: Store) -> Random {
        get!(self.world, (1), (Random))
    }

    fn set_random(self: Store, random: Random) {
        set!(self.world, (random))
    }
    
    #[inline(always)]
    fn user(self: Store, player: ContractAddress) -> User {
        get!(self.world, (player), (User))
    }
    #[inline(always)]
    fn set_user(self: Store, user: User) {
        set!(self.world, (user))
    }

    #[inline(always)]
    fn item(self: Store, player: ContractAddress, item_id: u16) -> Item {
        get!(self.world, (player, item_id), (Item))
    }
    #[inline(always)]
    fn set_item(self: Store, item: Item) {
        set!(self.world, (item))
    }

    fn items(self: Store, player: ContractAddress) -> Array<Item> {
        let user = self.user(player);

        let mut items = ArrayTrait::new();
        let mut index: u16 = 0;
        loop {
            items.append(self.item(player, index));

            index += 1;
            if (index >= user.inventory_cap) {
                break();
            }
        };

        items
    }
}