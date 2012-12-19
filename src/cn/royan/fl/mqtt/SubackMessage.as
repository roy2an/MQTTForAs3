package cn.royan.fl.mqtt
{
	/**
	 * 
	 * Fixed header
	 * --------------------------------------------------------------
	 * bit    |  7  |  6  |  5  |  4  |    3    |  2  |  1  |  0
	 * --------------------------------------------------------------
	 * byte 1 |    Message Type (9)   | DUP flag| QoS level |RETAIN
	 * --------------------------------------------------------------
	 *        |  1  |  0  |  0  |  1  |    x    |  x  |  x  |  x
	 * --------------------------------------------------------------
	 * byte 2 |  Remaining Length
	 * --------------------------------------------------------------
	 * 
	 * Remaining Length field
	 * The length of the payload. It can be a multibyte field.
	 * 
	 * Variable header
	 * The variable header contains the Message ID for the SUBSCRIBE message that is being acknowledged.
	 * The table below shows the format of the variable header.
	 * 
	 * --------------------------------------------------------
	 *         |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0
	 * --------------------------------------------------------
	 * byte 1  |  Message ID MSB
	 * --------------------------------------------------------
	 * byte 2  |  Message ID LSB
	 * --------------------------------------------------------
	 * 
	 * Payload
	 * The payload contains a vector of granted QoS levels. Each level corresponds to a topic name in the corresponding SUBSCRIBE message. 
	 * The order of QoS levels in the SUBACK message matches the order of topic name and Requested QoS pairs in the SUBSCRIBE message. 
	 * The Message ID in the variable header enables you to match SUBACK messages with the corresponding SUBSCRIBE messages.
	 * 
	 * The table below shows the Granted QoS field encoded in a byte.
	 * ------------------------------------------------------------------------------------------------------
	 * bit      |      7     |      6     |      5     |      4     |      3     |      2     |  1  |  0
	 * -------------------------------------------------------------------------------------------------------
	 *          |  Reserved  |  Reserved  |  Reserved  |  Reserved  |  Reserved  |  Reserved  |  QoS level
	 * -------------------------------------------------------------------------------------------------------
	 *          |      x     |      x     |      x     |      x     |      x     |      x     |
	 * -------------------------------------------------------------------------------------------------------
	 * 
	 * The upper 6 bits of this byte are not used in the current version of the protocol. They are reserved for future use.
	 * 
	 * The table below shows an example payload.
	 * 
	 * --------------------------------------------
	 * Granted QoS  |  0
	 * --------------------------------------------
	 * Granted QoS  |  2
	 * --------------------------------------------
	 * 
	 * The table below shows the format of this payload.
	 * 
	 * -----------------------------------------------------------------------------
	 *         |  Description      |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0
	 * -----------------------------------------------------------------------------
	 * byte 1  |  Granted QoS (0)  |  x  |  x  |  x  |  x  |  x  |  x  |  0  |  0
	 * -----------------------------------------------------------------------------
	 * byte 1  |  Granted QoS (2)  |  x  |  x  |  x  |  x  |  x  |  x  |  1  |  0
	 * -----------------------------------------------------------------------------
	 * 
	 */
	public class SubackMessage extends MQTTMessage
	{
		protected var msgid:int;
		
		public function SubackMessage()
		{
			super(MQTTMessage.SUBACK);
		}
		
		
		override public function serialize():void
		{
			super.serialize();
			
			this.readBytes(varHead, 0 , 2);
			this.readBytes(payLoad);
			
			this.position = 1;
			this.writeByte(varHead.length + payLoad.length);
			
			msgid = (varHead.readUnsignedByte() << 8) + varHead.readUnsignedByte();
		}
		
		public function readMessageID():int
		{
			return msgid;
		}
	}
}