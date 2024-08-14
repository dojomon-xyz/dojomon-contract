mod setup {
    // Core imports
    use core::option::OptionTrait;
use core::debug::PrintTrait;

    // Starknet imports
    use starknet::ContractAddress;
    use starknet::testing::{set_contract_address};

    // Dojo imports
    use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
    use dojo::test_utils::{spawn_test_world, deploy_contract};

    // Internal imports
    use dojomon::models::user::User;
    use dojomon::models::item::Item;

    use dojomon::systems::game_actions::{GameActions as game_actions, IGameActionsDispatcher, IGameActionsDispatcherTrait};

    // Constants

    fn PLAYER() -> ContractAddress {
        starknet::contract_address_const::<'PLAYER'>()
    }

    const PLAYER_NAME: felt252 = 'PLAYER';

    #[derive(Drop)]
    struct Context {
        player_id: ContractAddress,
        player_name: felt252,
    }

    #[derive(Drop)]
    struct Systems {
        game_actions: IGameActionsDispatcher,
    }

    #[inline(always)]
    fn spawn() -> (IWorldDispatcher, Systems, Context) {
        // [Setup] World
        let mut models = core::array::ArrayTrait::new();
        models.append(dojomon::models::user::user::TEST_CLASS_HASH);
        models.append(dojomon::models::item::item::TEST_CLASS_HASH);
        let world = spawn_test_world(models);

        // // [Setup] Systems
        let game_actions_address = world.deploy_contract('game_actions', game_actions::TEST_CLASS_HASH.try_into().unwrap(), array![].span());
        let systems = Systems {
            game_actions: IGameActionsDispatcher { contract_address: game_actions_address },
        };

        // [Setup] Context
        set_contract_address(PLAYER());
        let context = Context {
            player_id: PLAYER(),
            player_name: PLAYER_NAME
        };

        // [Return]
        (world, systems, context)
    }
}