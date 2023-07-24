# PTT
I Call it a Pay To Tell token , a smart contract under construction for a payment token that will be available on web3 for users to basically add descriptions to their transaction for money management as for example recurring bills


This Solidity smart contract is a payment contract named "MyPaymentContract" that uses the ERC20 token "PayToTell" (PTT) for payment purposes. Here's a simple explanation of how it works:

The contract "NonTransferableOwnable" is used to manage ownership, and only the contract creator is the owner.

The "PayToTell" contract is an ERC20 token with an added function "transferWithDescription" to transfer tokens along with a description. It also has a "mint" function to mint additional tokens, which can only be called by the contract owner.

The "MyPaymentContract" contract is the main payment contract, inheriting from "NonTransferableOwnable." It initializes by receiving the address of the "PayToTell" contract and mints 1000 PTT tokens to itself.

The "makePayment" function allows users to make payments to another address by transferring PTT tokens. The sender must have enough tokens to perform the transfer.

The "buyToken" function allows users to buy PTT tokens by sending Matic (ETH) to the contract. The contract calculates the number of tokens based on the sent amount and transfers the purchased tokens to the buyer.

The "withdraw" function allows the contract owner to withdraw the Matic (ETH) balance from the contract
