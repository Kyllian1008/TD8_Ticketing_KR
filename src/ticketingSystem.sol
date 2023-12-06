
pragma solidity ^0.8.13;

struct artist {
    bytes32 name;
    uint256 artistCategory;
    address owner;
    uint256 totalTicketSold;
}

struct venue {
    bytes32 name;
    uint256 capacity;
    uint256 commission;
    address owner;
}

struct concert {
    uint256 artistId;
    uint256 venueId;
    uint256 concertDate;
    uint256 ticketPrice;
    bool validatedByArtist;
    bool validatedByVenue;
    uint256 totalTicketSold;
    uint256 totalMoneyCollected;
}

struct ticket {
    uint256 concertId;
    address payable owner;
    bool isAvailable;
    bool isAvailableForSale;
    uint256 amountPaid;
}

contract  TicketingSystem {
    uint256 public artistCount = 1;
    uint256 public venueCount=1;
    uint256 public concertCount=1;
    uint256 public ticketCount=1;
    mapping(uint256 => artist) public artistsRegister;
    mapping(uint256 => venue) public venuesRegister;
    mapping(uint256 => concert) public concertsRegister;
    mapping(uint256 => ticket) public ticketsRegister;


    function createArtist(bytes32 _name,uint256 _artistCategory) public {

        artist memory newArtist = artist(_name,_artistCategory,msg.sender,0);

        artistsRegister[artistCount] = newArtist;
        artistCount++;
    }


    function modifyArtist(uint256 _artistId,bytes32 _name,uint256 _artistCategory,address _owner) public {

        require(artistsRegister[ _artistId].owner == msg.sender,"not the owner");

        artistsRegister[ _artistId].name = _name;
        artistsRegister[ _artistId].artistCategory = _artistCategory;
        artistsRegister[ _artistId].owner = _owner;
    }


    function createVenue(bytes32 _name, uint256 _capacity, uint256 _Comission) public {

        venue memory newVenue = venue(_name,_capacity,_Comission,msg.sender);

        venuesRegister[venueCount] = newVenue;
        venueCount++;
    }


    function modifyVenue(
        uint256 _venueId,
        bytes32 _name,
        uint256 _capacity,
        uint256 _standardComission,
        address payable _newOwner
    ) public {
        require(venuesRegister[ _venueId].owner == msg.sender,"not the venue owner");
        venuesRegister[ _venueId].name = _name;
        venuesRegister[ _venueId].capacity = _capacity;
        venuesRegister[ _venueId].commission = _standardComission;
        venuesRegister[ _venueId].owner = _newOwner;
    }


    function createConcert(uint _artistId, uint _venueId, uint _concertDate, uint _ticketPrice) public {
        concert memory newConcert = concert(_artistId,_venueId,_concertDate,_ticketPrice,false,false,0,0);
        concertsRegister[concertCount] = newConcert;
        concertCount++;
    }


    function validateConcert(uint256 _concertId) public {
        bool isArtist = msg.sender ==
            artistsRegister[concertsRegister[_concertId].artistId].owner;
        bool isVenue = msg.sender ==
            venuesRegister[concertsRegister[_concertId].venueId].owner;
        require(isArtist || isVenue, "not the artist or venue owner");
        if (isArtist) {
            concertsRegister[_concertId].validatedByArtist = true;
        }
        if (isVenue) {
            concertsRegister[_concertId].validatedByVenue = true;
        }
    }
    


    function emitTicket(uint256 _concertId,address payable _ticketOwner) public {
            require(
                msg.sender == artistsRegister[concertsRegister[_concertId].artistId].owner,
                "not the owner");
            ticket memory newTicket = ticket(_concertId,_ticketOwner,true,false,0);
            ticketsRegister[ticketCount] = newTicket;
            ticketCount++;
            concertsRegister[_concertId].totalTicketSold++;
        }

    function useTicket(uint256 _ticketId) public {
        require(
            msg.sender == ticketsRegister[_ticketId].owner,
            "sender should be the owner"
        );
        require(
            concertsRegister[ticketsRegister[_ticketId].concertId]
                .concertDate <= block.timestamp + 1 days,
            "should be used the d-day"
        );
        require(
            concertsRegister[ticketsRegister[_ticketId].concertId]
                .validatedByVenue,
            "should be validated by the venue"
        );
        ticketsRegister[_ticketId].isAvailable = false;
        ticketsRegister[_ticketId].owner = payable(address(0));
        ticketsRegister[_ticketId].isAvailableForSale = false;
    }


    function buyTicket(uint256 _concertId) public payable {
        ticket memory newTicket = ticket(_concertId,payable(msg.sender),true,false,msg.value);
        ticketsRegister[ticketCount] = newTicket;
        ticketCount++;
        concertsRegister[_concertId].totalTicketSold++;
        concertsRegister[_concertId].totalMoneyCollected += msg.value;
        payable(address(this)).transfer(msg.value);
    }

    fallback() external payable {}
    receive() external payable {}

    function transferTicket(uint256 _ticketId, address payable _newOwner) public {
        require(msg.sender == ticketsRegister[_ticketId].owner,"not the ticket owner");
        ticketsRegister[_ticketId].owner = _newOwner;
    }

    function cashOut(uint256 _concertId,address payable _cashOutAddress) public {
        require(
            msg.sender == artistsRegister[concertsRegister[_concertId].artistId].owner,"should be the artist"
            );
        require(
            concertsRegister[_concertId].concertDate <= block.timestamp,
            "should be after the concert"
        );
        uint256 totalMoneyCollected = concertsRegister[_concertId].totalMoneyCollected*concertsRegister[_concertId].ticketPrice;
        uint256 venueComission = (totalMoneyCollected*venuesRegister[concertsRegister[_concertId].venueId].commission)/10000;
        uint256 artistComission = totalMoneyCollected - venueComission;
        (bool success, ) = _cashOutAddress.call{value: artistComission}("");
        (bool success2, ) = payable(address(this)).call{value: venueComission}("");
        require(success && success2, "Transfer failed.");
    }

    function offerTicketForSale(uint256 _ticketId, uint256 _salePrice) public {
        require(
            msg.sender == ticketsRegister[_ticketId].owner,"should be the owner"
            );
        require(
            _salePrice < ticketsRegister[_ticketId].amountPaid,"should be less than the amount paid"
            );
        ticketsRegister[_ticketId].isAvailableForSale = true;
        ticketsRegister[_ticketId].amountPaid = _salePrice;
    }

    function buySecondHandTicket(uint256 _ticketId) public payable {
        require(
            msg.value >= ticketsRegister[_ticketId].amountPaid,"not enough funds"
        );
        require(
            ticketsRegister[_ticketId].isAvailableForSale,"should be available"
        );
        ticketsRegister[_ticketId].owner = payable(msg.sender);
        ticketsRegister[_ticketId].isAvailableForSale = false;
        ticketsRegister[_ticketId].amountPaid = msg.value;
    }
}

