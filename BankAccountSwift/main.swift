//
//  main.swift
//  BankAccountSwift
//
//  Created by Joe Harasz on 11/20/20.
//

import FlatBuffers

//Buffer size will grow automatically if need be
var builder = FlatBufferBuilder(initialSize: 1024)

//Savings account information
let savingsID: Int16 = 1518;
let savingsBalance: Float32 = 252.0;
let savingsInterestRate: Double = 0.00001;
let savingsStatus: status = status.open_;

//Checking account information
let checkingID: Int16 = 1519;
let checkingBalance: Float32 = 10.0;
let checkingInterestRate: Double = 0.000001;
let checkingStatus: status = status.open_;

//AccountDetails info
let owner = builder.create(string: "John Smith"); //Strings are not supported, you must use the builder to create a Offset<String>
let platinumReward: Bool = true;

//Create the accounts (offsets)
let savings = account.createaccount(&builder, accountId: savingsID, balance: savingsBalance, interestRate: savingsInterestRate, accountStatus: savingsStatus)
let checking = account.createaccount(&builder, accountId: checkingID, balance: checkingBalance, interestRate: checkingInterestRate, accountStatus: checkingStatus)

//Create the array of accounts
let accounts = builder.createVector(ofOffsets: [savings, checking])

//Create custom object using create API call and store in builder
let accountInformationDetails = accountInformation.createaccountInformation(&builder, offsetOfOwner: owner, platinumRewards: platinumReward, vectorOfAccounts: accounts)

//Set the end of the buffer using the accountInformation and finalize buffer
builder.finish(offset: accountInformationDetails);

// This must be called after `finish()`.
// `sizedByteArray` returns the finished buf of type [UInt8].
let buffer = builder.sizedByteArray;
assert(!buffer.isEmpty)
// or you can use to get an object of type Data (binary blob)
//let bufferData = ByteBuffer(data: builder.data);

accessBuffer(buffer: buffer);

func accessBuffer (buffer: [UInt8]) {
    //Get an accessor to the root object inside the buffer.
    let accountInformationInBuffer = accountInformation.getRootAsaccountInformation(bb: ByteBuffer(bytes: buffer));
    
    print("Flat buffer has been successfully accessed!");
    
    print("\nOverall account info\n-------------------------");
    //Access account info
    //Note: Do not force unwrap optionals unless you know the data type, otherwise the program will crash
    let ownerInBuffer: String = accountInformationInBuffer.owner!;
    let platinumRewardInBuffer = accountInformationInBuffer.platinumRewards;
    
    //See if this can support NSData (block of binary data or binary blob)
    //see if there is a constructor in builder or flat buffer for binary data
    //encryped binary blob -> decrypted -> put binary blob into builder
    //look at constructors around flat buffer builder or whatever / talk to sam
    
    //Access the accounts stored in account info
    let savingsAccountInBuffer: account = accountInformationInBuffer.accounts(at: 0)!;
    let checkingAccountInBuffer: account = accountInformationInBuffer.accounts(at: 1)!;
    
    //Grab the values stored in those accounts
    let savingsIDInBuffer: Int16 = savingsAccountInBuffer.accountId;
    let savingsBalanceInBuffer: Float32 = savingsAccountInBuffer.balance;
    let savingsInterestRateInBuffer: Double = savingsAccountInBuffer.interestRate;
    let savingsStatusInBuffer: status = savingsAccountInBuffer.accountStatus;
    
    //Grab the values stored in those accounts
    let checkingIDInBuffer: Int16 = checkingAccountInBuffer.accountId;
    let checkingBalanceInBuffer: Float32 = checkingAccountInBuffer.balance;
    let checkingInterestRateInBuffer: Double = checkingAccountInBuffer.interestRate;
    let checkingStatusInBuffer: status = checkingAccountInBuffer.accountStatus;
    
    print("Owner: ", ownerInBuffer);
    print("Platinum Rewards: ", platinumRewardInBuffer);
    
    print("\nSavings account details\n-------------------------");
    print("Account ID: ", savingsIDInBuffer);
    print("Balance: ", savingsBalanceInBuffer);
    print("Interest Rate: ", String(format: "%1.5f", savingsInterestRateInBuffer));
    print("Status: ", savingsStatusInBuffer);
    
    print("\nChecking account details\n-------------------------");
    print("Account ID: ", checkingIDInBuffer);
    print("Balance: ", checkingBalanceInBuffer);
    print("Interest Rate: ", String(format: "%1.6f", checkingInterestRateInBuffer));
    print("Status: ", checkingStatusInBuffer);
}
