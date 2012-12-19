package cn.royan.fl.mqtt
{
	/**
	 * 
	 * Fixed header
	 * --------------------------------------------------------------
	 * bit    |  7  |  6  |  5  |  4  |    3    |  2  |  1  |  0
	 * --------------------------------------------------------------
	 * byte 1 |    Message Type (2)   | DUP flag| QoS level |RETAIN
	 * --------------------------------------------------------------
	 *        |  0  |  0  |  1  |  0  |    x    |  x  |  x  |  x
	 * --------------------------------------------------------------
	 * byte 2 |  Remaining Length (2)
	 * --------------------------------------------------------------
	 *        |  0  |  0  |  0  |  0  |    0    |  0  |  1  |  0
	 * --------------------------------------------------------------
	 * 
	 * The DUP, QoS and RETAIN flags are not used in the CONNACK message.
	 * 
	 * Variable header
	 * 
	 * The variable header format is shown in the table below.
	 * 
	 * ----------------------------------------------------------------------------------------
	 *         |  Description                 |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0
	 * ----------------------------------------------------------------------------------------
	 * Topic Name Compression Response
	 * ----------------------------------------------------------------------------------------
	 * byte 1  |  Reserved values. Not used.  |  x  |  x  |  x  |  x  |  x  |  x  |  x  |  x
	 * ----------------------------------------------------------------------------------------
	 * Connect Return Code
	 * ----------------------------------------------------------------------------------------
	 * byte 2  |  Return Code	
	 * ----------------------------------------------------------------------------------------							
	 * 
	 * The values for the one byte unsigned Connect return code field are shown in the table below.
	 * 
	 * ----------------------------------------------------------------------------------------
	 * Enumeration  |  HEX  |  Meaning
	 * ----------------------------------------------------------------------------------------
	 *     0        |  0x00 |  Connection Accepted
	 * ----------------------------------------------------------------------------------------
	 *     1        |  0x01 |  Connection Refused: unacceptable protocol version
	 * ----------------------------------------------------------------------------------------
	 *     2        |  0x02 |  Connection Refused: identifier rejected
	 * ----------------------------------------------------------------------------------------
	 *     3        |  0x03 |  Connection Refused: server unavailable
	 * ----------------------------------------------------------------------------------------
	 *     4        |  0x04 |  Connection Refused: bad user name or password
	 * ----------------------------------------------------------------------------------------
	 *     5        |  0x05 |  Connection Refused: not authorized
	 * ----------------------------------------------------------------------------------------
	 *    6-255     | Reserved for future use
	 * ----------------------------------------------------------------------------------------
	 * 
	 * Return code 2 (identifier rejected) is sent if the unique client identifier is not between 1 and 23 characters in length.
	 * 
	 * Payload
	 * There is no payload.
	 * 
	 */
	public class ConnackMessage extends MQTTMessage
	{
		public static const RETURNCODE_ACCEPTED:uint 				= 0x00;
		public static const RETURNCODE_REFUSED_VERSION:uint 		= 0x01;//Connection Refused: unacceptable protocol version
		public static const RETURNCODE_REFUSED_IDENTIFIER:uint 	= 0x02;//Connection Refused: identifier rejected
		public static const RETURNCODE_REFUSED_SERVER:uint 		= 0x03;//Connection Refused: server unavailable
		public static const RETURNCODE_REFUSED_INPUT:uint 		= 0x04;//Connection Refused: bad user name or password
		public static const RETURNCODE_REFUSED_AUTHORIZED:uint 	= 0x05;//Connection Refused: not authorized
		
		protected var code:uint;
		
		public function ConnackMessage()
		{
			super(MQTTMessage.CONNACK);
		}
		
		override public function serialize():void
		{
			remainingLength = this.length - 2;
			
			this.position = 1;
			this.writeByte( remainingLength );
			this.position = 3;
			
			code = this.readUnsignedByte();
		}
		
		public function returnCode():uint
		{
			return code;
		}
	}
}