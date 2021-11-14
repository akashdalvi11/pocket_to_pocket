class Instrument{
    final int token;
    final String name;
    Instrument(this.token,this.name);
    String toString(){
        return '$name($token)';
    }
    @override
    bool operator==(o){
        if(o is Instrument) 
            return o.token == token 
            && o.name == name;
        return false;
    }
    @override
    int get hashCode => Object.hash(token,name);
}