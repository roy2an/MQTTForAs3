package cn.royan.fl.mqtt
{
	/**
	 * 
	 * Fixed header
	 * 
	 * --------------------------------------------------------------
	 * bit    |  7  |  6  |  5  |  4  |    3    |  2  |  1  |  0
	 * --------------------------------------------------------------
	 * byte 1 |    Message Type (11)  | DUP flag| QoS level |RETAIN
	 * --------------------------------------------------------------
	 *        |  1  |  0  |  1  |  1  |    x    |  x  |  x  |  x
	 * --------------------------------------------------------------
	 * byte 2 | Remaining length (2)
	 * --------------------------------------------------------------
	 *        |  0  |  0  |  0  |  0  |    0    |  0  |  1  |  0
	 * --------------------------------------------------------------
	 * 
	 * Remaining Length
	 * The length of the Variable Header (2 bytes).
	 * 
	 * Variable header
	 * 
	 * The variable header contains the Message ID for the UNSUBSCRIBE message that is being acknowledged. 
	 * 
	 * -------------------------------------------------------
	 * bit    |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0
	 * -------------------------------------------------------
	 * byte 1 |  Message ID MSB
	 * -------------------------------------------------------
	 * byte 2 |  Message ID LSB
	 * -------------------------------------------------------
	 * 
	 * Payload
	 * There is no payload.
	 * 
	 */
	public class UnsubackMessage extends MQTTMessage
	{
		protected var msgid:int;
		
		public function UnsubackMessage()
		{
			super(MQTTMessage.UNSUBACK);
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
	}
}