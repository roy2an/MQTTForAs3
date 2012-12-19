package cn.royan.fl.mqtt
{
	/**
	 * 
	 * Fixed header
	 * 
	 * --------------------------------------------------------------
	 * bit    |  7  |  6  |  5  |  4  |    3    |  2  |  1  |  0
	 * --------------------------------------------------------------
	 * byte 1 |    Message Type (10)  | DUP flag| QoS level |RETAIN
	 * --------------------------------------------------------------
	 *        |  1  |  0  |  1  |  0  |    0    |  0  |  1  |  x
	 * --------------------------------------------------------------
	 * byte 2 |  Remaining Length
	 * --------------------------------------------------------------
	 * 
	 * QoS level
	 * UNSUBSCRIBE messages use QoS level 1 to acknowledge multiple unsubscribe requests. 
	 * The corresponding UNSUBACK message is identified by the Message ID. Retries are handled in the same way as PUBLISH messages.
	 * 
	 * DUP flag
	 * Set to zero (0). This means that the message is being sent for the first time. See DUP for more details.
	 * 
	 * RETAIN flag
	 * Not used.
	 * 
	 * Remaining Length
	 * This is the length of the Payload. It can be a multibyte field.
	 * 
	 * Variable header
	 * The variable header contains a Message ID because an UNSUBSCRIBE message has a QoS level of 1. 
	 * See Message identifiers for more details.
	 * 
	 * The table below shows an example format for the variable header with a Message ID of 10.
	 * 
	 * ------------------------------------------------------------------------------
	 *         |     Description     |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0
	 * ------------------------------------------------------------------------------
	 * Message Identifier
	 * ------------------------------------------------------------------------------
	 * byte 1  |  Message ID MSB (0) |  0  |  0  |  0  |  0  |  0  |  0  |  0  |  0
	 * ------------------------------------------------------------------------------
	 * byte 2  |  Message ID LSB (10)|  0  |  0  |  0  |  0  |  1  |  0  |  1  |  0
	 * ------------------------------------------------------------------------------
	 * 
	 * Payload
	 * The client unsubscribes from the list of topics named in the payload. 
	 * The strings are UTF-encoded and are packed contiguously. 
	 * Topic names in a UNSUBSCRIBE message are not compressed. The table below shows an example payload.
	 * 
	 * ------------------------
	 * Topic Name  |  "a/b"
	 * ------------------------
	 * Topic Name  |  "c/d"
	 * ------------------------
	 * 
	 * The table below shows the format of this payload.
	 * 
	 * ------------------------------------------------------------------------------
	 *         |    Description    |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0
	 * ------------------------------------------------------------------------------
	 * Topic Name
	 * ------------------------------------------------------------------------------
	 * byte 1  |  Length MSB (0)   |  0  |  0  |  0  |  0  |  0  |  0  |  0  |  0
	 * ------------------------------------------------------------------------------
	 * byte 2  |  Length LSB (3)   |  0  |  0  |  0  |  0  |  0  |  0  |  1  |  1
	 * ------------------------------------------------------------------------------
	 * byte 3  |    'a' (0x61)     |  0  |  1  |  1  |  0  |  0  |  0  |  0  |  1
	 * ------------------------------------------------------------------------------
	 * byte 4  |    '/' (0x2F)     |  0  |  0  |  1  |  0  |  1  |  1  |  1  |  1
	 * ------------------------------------------------------------------------------
	 * byte 5  |    'b' (0x62)     |  0  |  1  |  1  |  0  |  0  |  0  |  1  |  0
	 * ------------------------------------------------------------------------------
	 * Topic Name
	 * ------------------------------------------------------------------------------
	 * byte 6  |  Length MSB (0)   |  0  |  0  |  0  |  0  |  0  |  0  |  0  |  0
	 * ------------------------------------------------------------------------------
	 * byte 7  |  Length LSB (3)   |  0  |  0  |  0  |  0  |  0  |  0  |  1  |  1
	 * ------------------------------------------------------------------------------
	 * byte 8  |    'c' (0x63)     |  0  |  1  |  1  |  0  |  0  |  0  |  1  |  1
	 * ------------------------------------------------------------------------------
	 * byte 9  |    '/' (0x2F)     |  0  |  0  |  1  |  0  |  1  |  1  |  1  |  1
	 * ------------------------------------------------------------------------------
	 * byte 10 |    'd' (0x64)     |  0  |  1  |  1  |  0  |  0  |  1  |  0  |  0
	 * ------------------------------------------------------------------------------
	 * 
	 * Response
	 * The server sends an UNSUBACK to a client in response to an UNSUBSCRIBE message.
	 * 
	 */
	public class UnsubscribeMessage extends MQTTMessage
	{
		protected var msgid:int;
		
		public function UnsubscribeMessage(topics:Array=null,qos:int=0)
		{
			super(MQTTMessage.UNSUBSCRIBE);
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