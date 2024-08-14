use starknet::ContractAddress;
 
#[derive(Model, Copy, Drop, Serde)]
#[dojo::model]
struct Item {
    #[key]
    player: ContractAddress,
    #[key]
    item_id: u8,    
    amount: u128,
}