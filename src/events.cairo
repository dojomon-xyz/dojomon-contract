use starknet::ContractAddress;

#[derive(Copy, Drop, Serde)]
#[dojo::model]
#[dojo::event]
struct Catched {
    #[key]
    player: ContractAddress,
    succeed: bool,
    item_id: u16,
}