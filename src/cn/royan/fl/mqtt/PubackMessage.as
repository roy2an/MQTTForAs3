package cn.royan.fl.mqtt
{
	/**
	 * 
	 * Fixed header
	 * 
	 * --------------------------------------------------------------
	 * bit    |  7  |  6  |  5  |  4  |    3    |  2  |  1  |  0
	 * --------------------------------------------------------------
	 * byte 1 |    Message Type (4)   | DUP flag| QoS level |RETAIN
	 * --------------------------------------------------------------
	 *        |  0  |  1  |  0  |  0  |    x    |  x  |  x  |  x
	 * --------------------------------------------------------------
	 * byte 2 |  Remaining Length (2)
	 * --------------------------------------------------------------
	 *        |  0  |  0  |  0  |  0  |    0    |  0  |  1  |  0
	 * --------------------------------------------------------------
	 * 
	 * Remaining Length field
	 * This is the length of the variable header (2 bytes). It can be a multibyte field.
	 * 
	 * Variable header
	 * 
	 * Contains the Message Identifier (Message ID) for the PUBLISH message that is being acknowledged. 
	 * The table below shows the format of the variable header.
	 * 
	 * --------------------------------------------------------
	 * bit     |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0
	 * --------------------------------------------------------
	 * byte 1  |  Message ID MSB
	 * --------------------------------------------------------
	 * byte 2  |  Message ID LSB
	 * --------------------------------------------------------
	 * 
	 * Payload
	 * There is no payload.
	 * 
	 * Actions
	 * When the client receives the PUBACK message, it discards the original message, because it is also received (and logged) by the server.
	 * 
	 */
	public class PubackMessage extends MQTTMessage
	{
		protected var msgid:int;
		
		public function PubackMessage()
		{
			super(MQTTMessage.PUBACK);
		}
		
		override public function serialize():void
		{
			remainingLength = this.length - 2;
			
			this.position = 1;
			this.writeByte( remainingLength );
			
			msgid = (this.readUnsignedByte() << 8) + this.readUnsignedByte();
		}
		
		public function readMessageID():int
		{
			return msgid;
		}
	}
}