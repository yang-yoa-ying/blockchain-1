pragma solidity ^0.6.0;
contract bank{
    mapping(address => uint256) public balances; //地址映射到存款金額
    mapping(string => address) public students;//學號映射到地址
    address payable public owner; //銀行的擁有者，會在constructor做設定
    mapping(address => uint256) public count;
    uint256 private a;

    constructor() public{
        owner = owner = msg.sender;
    } //設定owner為創立合約的人
    
    function deposit() public payable{
        require( msg.value > 0, "沒有錢匯入啊");
        balances[msg.sender] += msg.value;
        //可以讓使用者call這個函數把錢存進合約地址，並且在balances中紀錄使用者的帳戶金額
    }
    
    
    function withdraw(uint256 wantmoney)public payable{
        require(wantmoney <= balances[msg.sender] , "沒有足夠的錢錢");
        balances[msg.sender] =balances[msg.sender] - wantmoney;
        msg.sender.transfer(wantmoney);
        //可以讓使用者從合約提錢，這邊需要去確認合約裡的餘額 >= 想提的金額
    }
    
    function transfer (uint256 turnmoney,address toaddresss) public payable{
        require(turnmoney <= balances[msg.sender] , "沒有足夠的錢錢");
        balances[msg.sender] = balances[msg.sender] - turnmoney;
        balances[toaddresss] += turnmoney;
        //可以讓使用者從合約轉帳給某個地址，這邊需要去確認合約裡的餘額 >= 想轉的金額
        //實現的是銀行內部轉帳，也就是說如果轉帳成功balances的目標地址會增加轉帳金額
    }

    function getBalance()public view returns(uint256){
        return balances[msg.sender];
        //從balances回傳使用者的銀行帳戶餘額
    }
    
    function getBankBalance()public view returns(uint256){
        require(owner == msg.sender,"需要為owner喔");
        return address(this).balance;
        //回傳銀行合約的所有餘額，設定為只有owner才能呼叫成功
    }
    
    function enroll(string memory studentnumber)public{
        students[studentnumber] = msg.sender;
    }
    
    function fallback() public{
        require(owner == msg.sender,"需要為owner喔");
        selfdestruct(owner);
        //當觸發fallback時，檢查觸發者是否為owner，是則自殺合約，把合約剩餘的錢轉給owner
    }
    
    function lendmoney (uint256 lendhowmuchmoney) public payable{
        a = address(this).balance - balances[msg.sender];
        require(lendhowmuchmoney <= a , "銀行沒錢借" );
        balances[msg.sender] += lendhowmuchmoney;
        count[msg.sender] += lendhowmuchmoney;
        //借錢功能
    }
    
     function howmuchtolend()public view returns(uint256){
        return count[msg.sender];
        //從balances回傳使用者的銀行帳戶餘額
    }
}
//參考資料:https://ithelp.ithome.com.tw/articles/10205145
