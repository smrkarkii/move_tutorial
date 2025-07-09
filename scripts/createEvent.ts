import { Transaction } from "@mysten/sui/transactions";
import getExecStuff from "./utils/execStuff";

// Contract constants
const PACKAGE_ID = process.env.packageId;
const AdminCap = process.env.adminCap;
const EVENT_TYPE = `${PACKAGE_ID}::ticket_management::Event`;
const TICKET_TYPE = `${PACKAGE_ID}::ticket_management::Ticket`;
const ADMIN_CAP_TYPE = `${PACKAGE_ID}::ticket_management::AdminCap`;

async function createEvent(eventName: string) {
    // Create a new transaction block
    const { keypair, client } = getExecStuff();
    const tx = new Transaction();

    try{
        // Call the create_event function from the Move contract
    tx.moveCall({
        target: `${PACKAGE_ID}::ticket_management::create_event`,
        arguments: [
            // Pass the AdminCap
            tx.object(AdminCap),
            // Pass the event name
            tx.pure.string(eventName)
        ]
    });

   const result = await client.signAndExecuteTransaction({
      signer: keypair,
      transaction: tx,
      options: {
        showEffects: true,
        showObjectChanges: true,
      },
    });
    console.log("✅ Transaction successful!");
    console.log("Digest:", result.digest);
    }
    catch(err){
        console.log(err,"error")
    }
}

createEvent("Musical Concert");