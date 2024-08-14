use starknet::ContractAddress;
 
#[derive(Model, Copy, Drop, Serde)]
#[dojo::model]
struct User {
    #[key]
    player: ContractAddress,
    inventory_cap: u16
}