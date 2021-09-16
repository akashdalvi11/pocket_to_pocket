class Instrument{
    final int token;
    final String name;
    Instrument(this.token,this.name);
    String toString(){
        return token.toString() + " " + name;
    }
}