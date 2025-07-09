
module move_project::ticket_management;


//imports
use std::string;
use sui::url;

//Errors module
const ETicketAlreadyUsed: u64 = 0;

public struct Event has key{
    id:UID,
    event_name:string::String,
    sold_tickets:vector<ID>
}

public struct Ticket has key , store{
    id:UID,
    event_id:ID,
    ticket_number:u64,
    is_used:bool,
    image_url:url::Url

}

// Admin Capability for event creation
    public struct AdminCap has key {
        id: UID
    }

// Module initialization to create admin capability
    fun init(ctx: &mut TxContext) {
        transfer::transfer(
            AdminCap { id: object::new(ctx) }, 
            tx_context::sender(ctx)
        );
    }

public fun create_event(_: &AdminCap,event_name: string::String,ctx:&mut TxContext) {
    let event = Event {
        id: object::new(ctx),
        event_name:event_name,
        sold_tickets: vector::empty()

    };
    //
    transfer::share_object(event);
}

#[allow(lint(self_transfer))]
public fun buy_ticket(event:&mut Event,ctx:&mut TxContext) {
    let ticket = Ticket {
        id:object::new(ctx),
        is_used: false,
        event_id: object::id(event),
        ticket_number: event.sold_tickets.length(),
        image_url: url::new_unsafe_from_bytes(b"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSup6BfzGc04Pjzim-R1_Um-DGVy1AoTqouIA&s")
    };
    event.sold_tickets.push_back(object::id(&ticket));
    transfer::public_transfer(ticket,ctx.sender());

}

public fun use_ticket(ticket:&mut Ticket) {
    assert!(!ticket.is_used, ETicketAlreadyUsed);
    ticket.is_used =  true;
}

public fun delete_ticket(ticket:Ticket){
    let Ticket {id, event_id:_, is_used:_, ticket_number:_, image_url: _} = ticket;
    object::delete(id);
}

