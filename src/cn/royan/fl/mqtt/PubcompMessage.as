package cn.royan.fl.mqtt
{
	/**
	 * 
	 * Fixed header
	 * 
	 * --------------------------------------------------------------
	 * bit    |  7  |  6  |  5  |  4  |    3    |  2  |  1  |  0
	 * --------------------------------------------------------------
	 * byte 1 |    Message Type (7)   | DUP flag| QoS level |RETAIN
	 * --------------------------------------------------------------
	 *        |  0  |  1  |  1  |  1  |    x    |  x  |  x  |  x
	 * --------------------------------------------------------------
	 * byte 2 |    Remaining Length (2)
	 * --------------------------------------------------------------
	 *        |  0  |  0  |  0  |  0  |    0    |  0  |  1  |  0
	 * --------------------------------------------------------------
	 * 
	 * Remaining Length field
	 * The length of the variable header (2 bytes). It can be a multibyte field.
	 * 
	 * Variable header
	 * The variable header contains the same Message ID as the acknowledged PUBREL message.
	 * 
	 * ---------------------------------------------------------
	 * bit     |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0
	 * ---------------------------------------------------------
	 * byte 1  |  Message ID MSB
	 * ---------------------------------------------------------
	 * byte 2  |  Message ID LSB
	 * ---------------------------------------------------------
	 * 
	 * Payload
	 * There is no payload.
	 * 
	 * Actions
	 * When the client receives a PUBCOMP message, it discards the original message because it has been delivered, exactly once, to the server.
	 * 
	 */
	public class PubcompMessage extends MQTTMessage
	{
		protected var msgid:int;
		
		public function PubcompMessage(msgid:int=0)
		{
			super(MQTTMessage.PUBCOMP);
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