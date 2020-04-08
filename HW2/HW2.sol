pragma solidity ^0.6.0;

contract bank{
    
    mapping (string => address) public students; //學號映射到地址
    mapping (address => int256) private balances; //地址映射到存款金額
    mapping (address => bool) private banckenroll;
    address payable public owner; //銀行的擁有者，會在constructor做設定
    int256 private banckbalances;
    
    //設定owner為創立合約的人
    constructor() public {
        owner = msg.sender;
    }
    
    //透過students把學號映射到使用者的地址
    function enroll(string memory stduentId) public{
        require(banckenroll[msg.sender] != true,'已註冊過');
        students[stduentId] = msg.sender;
        banckenroll[msg.sender] = true;
    }
    
    //從balances回傳使用者的帳戶餘額
    function getBalance() external view returns (int256){
        return balances[msg.sender];
    }
    
    //可以讓使用者call這個函數把錢存進合約地址，並且在balances中紀錄使用者的帳戶金額
    function deposit() public payable{
        // msg.sender.transfer(msg.value);
        require(banckenroll[msg.sender] == true,'尚未註冊');
        balances[msg.sender] += int256(msg.value);
        banckbalances += int256(msg.value);
    }
    
    //回傳銀行合約的所有餘額，設定為只有owner才能呼叫成功
    function getBankBalance() external view returns(int256){
        require(owner == msg.sender ,'沒有權限');
        return banckbalances;
    }
    
    //可以讓使用者從合約提錢，這邊需要去確認合約裡的餘額 >= 想提的金額
    function withdraw(uint248 withdrawAmount) public payable{
        require(balances[msg.sender] >= withdrawAmount ,'餘額不足');
        banckbalances -= int256(withdrawAmount);
        balances[msg.sender] -= int256(withdrawAmount);
        msg.sender.transfer(withdrawAmount);
    }
    
    //可以讓使用者從合約轉帳給某個地址，這邊需要去確認合約裡的餘額 >= 想轉的金額
    //實現的是銀行內部轉帳，也就是說如果轉帳成功balances的目標地址會增加轉帳金額
    function transfer(uint248 transferAmount, address studentAddress) public payable{
        require(balances[msg.sender] >= transferAmount ,'餘額不足');
        balances[msg.sender] -= int256(transferAmount);
        balances[studentAddress] += int256(transferAmount);
    }
    
    //當觸發fallback時，檢查觸發者是否為owner，是則自殺合約，把合約剩餘的錢轉給owner
    fallback() external {
        require(owner == msg.sender,'Permission denied');
        selfdestruct(owner);
    }

}    


