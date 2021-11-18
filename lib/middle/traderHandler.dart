import '../injector.dart';
import '../core/dataForest/dataSpecForest.dart';
import '../core/instrument.dart';
import '../core/trade.dart';
import '../core/traderMeta/traderMeta.dart';
import '../core/traderMeta/historicalTraderMeta.dart';
import '../core/traders/trader.dart';
import '../core/traders/historicalTrader.dart';
import '../backend/backendAdapter.dart';
import '../ui/uiAdapter.dart';
class TraderHandler{
    Map<TraderMeta,Trader> _traders = {};
    Map<TraderMeta,List<Trade>> trades = {};
    addTrader(TraderMeta m,DataSpecForest specs){
        trades[m] = [];
        _traders[m] = Trader(specs,
            getIt<BackendAdapter>().getStream(m.instrument.token,m.interval),
            trades[m]!,
            (entry){
                // getIt<BackendAdapter>().sendSignals(m,s);
                trades[m]!.add(Trade(m.instrument,entry));
                getIt<UIAdapter>().notifyListeners();
            },
            (exit){
                trades[m]!.last.addExit(exit);
                getIt<UIAdapter>().notifyListeners();
            }
        );
    }
    removeTrader(TraderMeta m) async{
        await getIt<BackendAdapter>().disposeStream(m.instrument.token,m.interval);
        _traders.remove(m);
        trades.remove(m);
    }
    addHistoricalTrader(HistoricalTraderMeta m,DataSpecForest specs){
        HistoricalTrader(
            m.instrument,
            specs,
            m.from,
            ()=>getIt<BackendAdapter>().getHistoricalData(m.instrument.token,m.interval),
            (List<Trade> tradesRecieved){
                trades[m] = tradesRecieved;
                getIt<UIAdapter>().notifyListeners();
            },
            (String s){
                print(s);
            }
        );
    }
}

 