function stepToDate() {
    FadeAllLeft();
    document.getElementById('GetDate').classList.remove('halfScreenBlockFaded');
};
function stepToTime() {
    FadeAllLeft();
    document.getElementById('GetTime').classList.remove('halfScreenBlockFaded');
}; 
function stepToCustomer() {
    FadeAllLeft();
    document.getElementById('GetCustomer').classList.remove('halfScreenBlockFaded');
    document.getElementById('MainContent_CustomerContactNumberTextbox').focus();
};
function stepToOrder() {
    FadeAllLeft();
    document.getElementById('GetOrder').classList.remove('halfScreenBlockFaded');
};
function FadeAllLeft() {
    document.getElementById('GetDate').classList.add('halfScreenBlockFaded');
    document.getElementById('GetTime').classList.add('halfScreenBlockFaded');
    document.getElementById('GetCustomer').classList.add('halfScreenBlockFaded');
    document.getElementById('GetOrder').classList.add('halfScreenBlockFaded');
};