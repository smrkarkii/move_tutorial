import { Transaction } from "@mysten/sui/transactions";
import getExecStuff from "./utils/execStuff";

// Contract constants
const PACKAGE_ID = process.env.packageId;

async function buyTicket(eventId: string) {
    // Create a new transaction block
    const { keypair, client } = getExecStuff();
    const tx = new Transaction();

    try {
        // Call the buy_ticket function from the Move contract
        tx.moveCall({
            target: `${PACKAGE_ID}::ticket_management::grant_ticket`,
            arguments: [
                // Pass the event object
                tx.object(eventId)
            ]
        });

        tx.moveCall({
            target: `${PACKAGE_ID}::ticket_management::grant_ticket`,
            arguments: [
                // Pass the event object
                tx.object(eventId)
            ]
        });

        tx.moveCall({
            target: `${PACKAGE_ID}::ticket_management::grant_ticket`,
            arguments: [
                // Pass the event object
                tx.object(eventId)
            ]
        });

        // Sign and execute the transaction
        const result = await client.signAndExecuteTransaction({
            signer: keypair,
            transaction: tx,
            options: {
                showEffects: true,
                showObjectChanges: true,
            },
        });

        console.log("✅ Ticket purchased successfully!");
        console.log("Digest:", result.digest);

        // Optionally, return the ticket details or transaction result
        return result;
    } catch (err) {
        console.error("Error purchasing ticket:", err);
        throw err;
    }
}

// Example usage
buyTicket(process.env.event1);