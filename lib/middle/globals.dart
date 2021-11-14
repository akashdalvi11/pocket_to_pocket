class Globals{
	DateTime historicalBufferStart = DateTime.now().subtract(Duration(days:2));
	Globals(){
		historicalBufferStart = historicalBufferStart.subtract(
			Duration(hours:historicalBufferStart.hour,
					minutes:historicalBufferStart.minute,
					seconds:historicalBufferStart.second,
					milliseconds:historicalBufferStart.millisecond,
					microseconds:historicalBufferStart.microsecond
			)
		);
	}
}