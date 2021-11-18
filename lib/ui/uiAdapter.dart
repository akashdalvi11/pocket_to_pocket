import 'package:flutter/material.dart';
import '../injector.dart';
import '../core/dataForest/dataSpecForest.dart';
import '../core/dataForest/interfaceSpecNode.dart';
import '../core/dataForest/dataSpecNode.dart';
import '../core/data/interfaceData/ohlc.dart';
import '../core/data/heikenAshi.dart';
import '../core/data/ema.dart';
import '../core/data/sma.dart';
import '../core/data/stochastic.dart';
import '../core/traderMeta/traderMeta.dart';
import '../core/traderMeta/historicalTraderMeta.dart';
import '../core/instrument.dart';
import '../core/trade.dart';
import '../middle/traderHandler.dart';
import '../middle/globals.dart';
import '../backend/backendAdapter.dart';
import 'notifier.dart';
class UIAdapter extends ChangeNotifier {
    final Notifier _notifier = Notifier();
    bool bankNiftyAdded = false;
    final Map<TraderMeta,List<Trade>> trades = getIt<TraderHandler>().trades;
    List<String>? current;
    DateTime historicalBufferStart = getIt<Globals>().historicalBufferStart;
    DateTime historicalEntry = getIt<Globals>().historicalBufferStart.add(Duration(days:1,hours:9:,minutes:15));
    final fixedSpecs = DataSpecForest([
                InterfaceSpecNode<OHLC>([
                    DataSpecNode<HeikenAshi>({}, [
                        DataSpecNode<EMA>({'period':9},[]),
                        DataSpecNode<Stochastic>({'period':9},[
                            DataSpecNode<SMA>({'period':3},[
                                DataSpecNode<SMA>({'period':3},[])
                            ])
                        ])
                    ])
                ])
            ]);
    final fixedInstrument = Instrument(260105, "NIFTYBANK");
    initialiseNotifier() async {
        await _notifier.setupNotifications();
    }

    initializeBackend() async {
        await getIt<BackendAdapter>().init();
        _notifier.notify("loaded", "...");
    }
    test(){
    
    }
    addTrader(){
        var om = TraderMeta(fixedInstrument,5);
        getIt<TraderHandler>().addTrader(om,fixedSpecs);
        bankNiftyAdded = true;
        notifyListeners();
    }
    removeTrader(){
        getIt<TraderHandler>().removeTrader(TraderMeta(fixedInstrument,5));
        bankNiftyAdded = false;
        notifyListeners();
    }
    addHistoricalTrader() {
        var hom = HistoricalTraderMeta(fixedInstrument,5,historicalEntry);
        getIt<TraderHandler>().addHistoricalTrader(hom,fixedSpecs);
        notifyListeners();
    }
    changeBufferStart(DateTime? d){
        if(d != null && d!= historicalBufferStart){
            getIt<Globals>().historicalBufferStart = d;
            historicalBufferStart = d;
            notifyListeners();
        }
    }
    changeHistoricalEntry(DateTime? d){
        if(d != null && d!= historicalEntry){
            historicalEntry = d.add(Duration(hours:9,minutes:15));
            notifyListeners();
        }
    }
    sendError(String error) {
        _notifier.notify("error", error);
    }
}
