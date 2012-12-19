package cn.royan.fl.mqtt
{
	/**
	 * 
	 * Fixed header
	 * --------------------------------------------------------------
	 * bit    |  7  |  6  |  5  |  4  |    3    |  2  |  1  |  0
	 * --------------------------------------------------------------
	 * byte 1 |    Message Type (14)  | DUP flag| QoS level |RETAIN
	 * --------------------------------------------------------------
	 *        |  1  |  1  |  1  |  0  |    x    |  x  |  x  |  x
	 * --------------------------------------------------------------
	 * byte 2 |  Remaining Length (0)
	 * --------------------------------------------------------------
	 *        |  0  |  0  |  0  |  0  |    0    |  0  |  0  |  0
	 * --------------------------------------------------------------
	 * 
	 * The DUP, QoS, and RETAIN flags are not used.
	 * 
	 * Variable header
	 * There is no variable header.
	 * 
	 * Payload
	 * There is no payload.
	 * 
	 */
	public class DisconnectMessage extends MQTTMessage
	{
		public function DisconnectMessage()
		{
			super(MQTTMessage.DISCONNECT);
		}
	}
}