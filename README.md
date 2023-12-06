<<<<<<< HEAD 
# Kyllian Rousseleau TD 8 Blockchain Programming 
# Test Driven Programming

The goal of this TD is to understand the concept of test driven development. Write tests first, contracts after.

You are going to build a decentralized ticketing system.
Artists, Venues and users can interact with each others to create, sell, transfer tickets/concerts.

Simply run `forge test` (or `forge test --via-ir` if there is a gas issue). All the tests must be green.

You can run a unique file by adding the `--match-path test/x.t.sol` parameter.
`forge test --via-ir --match-path test/6_ticketSelling.sol`

Place a contract file called `ticketingSystem.sol` in src/, the contract name must be `TicketingSystem`.

CLONE THE REPO THEN:
Install the dependencies. Deps in Foudry are git submodules, you have to run `git submodule init` and `git submodule update`


## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
=======

# output

PS C:\OneDrive_Fake\Bureau\ESILV\SEMESTRE 7\Blockchain_prog\TD6\Ticketing_system> forge test --via-ir
[⠰] Compiling...
No files changed, compilation skipped

Running 2 tests for test/2_creatingVenue.sol:VenueProfileTest
[PASS] testCreateVenueProfile() (gas: 214019)
[PASS] testModifyVenueProfile() (gas: 128589)
Test result: ok. 2 passed; 0 failed; 0 skipped; finished in 29.01ms

Running 3 tests for test/4_TicketBuyingAndTransferring.sol:TicketManagementTest
[PASS] testBuyingTicket() (gas: 244065)
[PASS] testTransferringTickets() (gas: 151770)
[PASS] testUsingBoughtTickets() (gas: 135750)
Test result: ok. 3 passed; 0 failed; 0 skipped; finished in 28.68ms

Running 3 tests for test/6_ticketSelling.sol:TicketSellingTest
[PASS] testBuyingAuctionnedTicket() (gas: 42920)
[PASS] testSellingTicket() (gas: 34905)
[PASS] testUsingTicketWhileOnSale() (gas: 37909)
Test result: ok. 3 passed; 0 failed; 0 skipped; finished in 26.60ms

Running 2 tests for test/1_creatingArtistProfile.sol:ArtistProfileTest
[PASS] testCreateArtistProfile() (gas: 165947)
[PASS] testModifyArtistProfile() (gas: 99879)
Test result: ok. 2 passed; 0 failed; 0 skipped; finished in 29.61ms

Running 3 tests for test/3_concertManagement.sol:ConcertManagmentTest
[FAIL. Reason: Assertion failed.] testCreateConcert() (gas: 299626)
[PASS] testEmitTickets() (gas: 434313)
[PASS] testUseTicket() (gas: 411827)
Test result: FAILED. 2 passed; 1 failed; 0 skipped; finished in 29.56ms

Ran 5 test suites: 12 tests passed, 1 failed, 0 skipped (13 total tests)

Failing tests:
Encountered 1 failing test in test/3_concertManagement.sol:ConcertManagmentTest
[FAIL. Reason: Assertion failed.] testCreateConcert() (gas: 299626)

Encountered a total of 1 failing tests, 12 tests succeeded
# Ticketing_system
>>>>>>> a49fe871f34fba0dffc4be3c42693b61e77137d9
