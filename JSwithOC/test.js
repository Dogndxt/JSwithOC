
//计算阶乘
var factorial = function(n) {

    if (n < 0) return;
    if (n == 1) return 1;
    return n * factorial(n - 1);

};