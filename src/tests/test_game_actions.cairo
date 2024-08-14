// Core imports
use core::debug::PrintTrait;

// Starknet imports
use starknet::testing::set_contract_address;

// Dojo imports
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

// Internal imports
use dojomon::store::{Store, StoreTrait};
use dojomon::tests::setup::{setup, setup::Systems, setup::Context};
use dojomon::systems::game_actions::{IGameActionsDispatcher, IGameActionsDispatcherTrait};

#[test]
fn test_character() {
    // [Setup]
    let (world, systems, context) = setup::spawn();
    let store = StoreTrait::new(world);

    systems.game_actions.catch(
        array![0, 1],
        array![0, 10_000],
    );
    // let user = store.user(context.player_id);
    let items = store.items(context.player_id);

    assert(*items.at(1).amount == 1, 'balance expected = 1');

    // let mut user_data = store.user_data(context.player_id);
    // assert(user_data.balance == DEFAULT_BALANCE - 100, 'invalid balance value');

    // systems.game_actions.buy(1);
    // user_data = store.user_data(context.player_id);
    // user_data.balance.print();

    // systems.game_actions.merge(0, 1);
    
    // let mut char0 = store.character(context.player_id, 0);
    // char0.level.print();

    // let rates = systems.game_actions.get_character_idle_rate(array![0,1,2,3,4,5,6,7,8,9,10]);
    // let len = rates.len();
    // let mut index = 0;
    // loop {
    //     (*rates.at(index)).print();
    //     index += 1;
    //     if (index >= len) {
    //         break();
    //     }
    // };
}

