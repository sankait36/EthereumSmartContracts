pragma solidity ^0.4.18;

contract SplitIt {
    
    address[] employees = [0x8B6047e06184F990e09dEA0876f47f0D23a248C9, 
                           0x5e42A660227eBa76daD7A2DC10012F68d348C287]; //These are test addresses, DO NOT SEND EHTER
    uint total_received = 0;
    mapping (address => uint) withdrawn_amt;
    
    /* Constructor */
    // Payable required to receive ether
    function SplitIt() public payable {
        updateTotalReceived();
    }
    
    function () public payable {
        updateTotalReceived();
    }
    
    function updateTotalReceived() internal {
        total_received += msg.value; //msg.value is whatever is in the initial ether inserted
    }
    
    modifier canWithdraw() {
        bool contains = false;
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i] == msg.sender) {
                contains = true;
                // No break here to make sure all employees pay the same gas price
                // Otherwise first employee pays lesser than the last one
            }
        }
        require(contains);
        _;
    }
    
    // A withdraw function is required to send ether from the contract
    // externally. If using payable make sure withdraw exists as well
    function withdraw() public canWithdraw {
        uint amt_allocated = total_received/employees.length;
        uint amt_withdrawn = withdrawn_amt[msg.sender];
        uint amount = amt_allocated - amt_withdrawn;
        withdrawn_amt[msg.sender] = amt_withdrawn + amount;
        
        if (amount > 0) {
            msg.sender.transfer(amount);
        }
        
    }
}