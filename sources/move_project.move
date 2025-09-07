
module move_project::ticket_management;


//imports
use std::string;
use sui::url;
use sui::package;
use sui::display;

//Errors module
const ETicketAlreadyUsed: u64 = 0;

public struct Event has key{
    id:UID,
    event_name:string::String,
    sold_tickets: vector<ID>,
}

public struct TICKET_MANAGEMENT {} has drop;

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
    fun init(_witness:TICKET_MANAGEMENT, ctx: &mut TxContext) {

        let publisher = package::claim(_witness, ctx);
        let mut display = display::new<Ticket>(&publisher, ctx);

        display.add(b"name".to_string(), b"VTicket NFT".to_string());
        display.add(b"description".to_string(), b"The Ticket NFT for Event".to_string());
        display.add(b"image_url".to_string(), b"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSup6BfzGc04Pjzim-R1_Um-DGVy1AoTqouIA&s".to_string());
        display.update_version();

        transfer::transfer(
            AdminCap { id: object::new(ctx) }, 
            tx_context::sender(ctx)
        );
        transfer::public_transfer(publisher, ctx.sender());
        transfer::public_transfer(display, ctx.sender());
    }

public fun create_event(_: &AdminCap,event_name: string::String,ctx:&mut TxContext) {
    let event = Event {
        id: object::new(ctx),
        event_name:event_name,
        sold_tickets: vector::empty(),
        
    };
    //
    transfer::share_object(event);
}

#[allow(lint(self_transfer))]
public fun grant_ticket(event:&mut Event, ctx:&mut TxContext) {
    let ticket = Ticket {
        id:object::new(ctx),
        is_used: false,
        event_id: object::id(event),
        ticket_number: event.sold_tickets.length() + 1,
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

