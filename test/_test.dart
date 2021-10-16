import 'dart:async';
void main() async {
    Map<String,int> a = {'a':5};
    print('wer');
    doSomething(a['a']);
}
int doSomething(int a){
    return a;
}
// int doSomething(Type t){
//     switch(t){
//         case List:
//             return 5;
//         default:
//             throw "error";
//     }
// }