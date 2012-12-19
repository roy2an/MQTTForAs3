package cn.royan.fl.mqtt
{
	/**
	 * 
	 * Fixed header
	 * 
	 * --------------------------------------------------------------
	 * bit    |  7  |  6  |  5  |  4  |    3    |  2  |  1  |  0
	 * --------------------------------------------------------------
	 * byte 1 |    Message Type (1)   | DUP flag| QoS level |RETAIN
	 * --------------------------------------------------------------
	 *        |  0  |  0  |  0  |  1  |    x    |  x  |  x  |  x
	 * --------------------------------------------------------------
	 * byte 2 |    Remaining Length
	 * --------------------------------------------------------------
	 * 
	 * The DUP, QoS, and RETAIN flags are not used in the CONNECT message.
	 * 
	 * Remaining Length is the length of the variable header (12 bytes) and the length of the Payload. This can be a multibyte field.
	 * 
	 * Variable header
	 * 
	 * ---------------------------------------------------------------------------------
	 *               |  Description      |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0
	 * ---------------------------------------------------------------------------------
	 * Protocol Name
	 * ---------------------------------------------------------------------------------
	 * byte 1        |  Length MSB (0)   |  0  |  0  |  0  |  0  |  0  |  0  |  0  |  0
	 * ---------------------------------------------------------------------------------
	 * byte 2        |  Length LSB (6)   |  0  |  0  |  0  |  0  |  0  |  1  |  1  |  0
	 * ---------------------------------------------------------------------------------
	 * byte 3        |      'M'          |  0  |  1  |  0  |  0  |  1  |  1  |  0  |  1
	 * ---------------------------------------------------------------------------------
	 * byte 4        |      'Q'          |  0  |  1  |  0  |  1  |  0  |  0  |  0  |  1
	 * ---------------------------------------------------------------------------------
	 * byte 5        |      'I'          |  0  |  1  |  0  |  0  |  1  |  0  |  0  |  1
	 * ---------------------------------------------------------------------------------
	 * byte 6        |      's'          |  0  |  1  |  1  |  1  |  0  |  0  |  1  |  1
	 * ---------------------------------------------------------------------------------
	 * byte 7        |      'd'          |  0  |  1  |  1  |  0  |  0  |  1  |  0  |  0
	 * -------------------------------- ------------------------------------------------
	 * byte 8        |      'p'          |  0  |  1  |  1  |  1  |  0  |  0  |  0  |  0
	 * ---------------------------------------------------------------------------------
	 * Protocol Version Number
	 * ---------------------------------------------------------------------------------
	 * byte 9        |  Version (3)      |  0  |  0  |  0  |  0  |  0  |  0  |  1  |  1
	 * ---------------------------------------------------------------------------------
	 * Connect Flags
	 * ---------------------------------------------------------------------------------
	 *               |User name flag (1) |     |     |     |     |     |     |     | 
	 *               |Password flag (1)  |     |     |     |     |     |     |     | 
	 *               |Will RETAIN (0)    |     |     |     |     |     |     |     | 
	 * byte 10       |Will QoS (01)      |  1  |  1  |  0  |  0  |  1  |  1  |  1  |  x
	 *               |Will flag (1)      |     |     |     |     |     |     |     | 
	 *               |Clean Session (1)	 |     |     |     |     |     |     |     | 
	 * ---------------------------------------------------------------------------------
	 * 	Keep Alive timer
	 * ---------------------------------------------------------------------------------
	 * byte 11       |Keep Alive MSB (0) |  0  |  0  |  0  |  0  |  0  |  0  |  0  |  0
	 * ---------------------------------------------------------------------------------
	 * byte 12       |Keep Alive LSB (10)|  0  |  0  |  0  |  0  |  1  |  0  |  1  |  0
	 * ---------------------------------------------------------------------------------
	 * 
	 * Payload
	 * The payload of the CONNECT message contains one or more UTF-8 encoded strings, based on the flags in the variable header.
	 * The strings, if present, must appear in the following order:
	 * 
	 * Client Identifier
	 * Will Topic
	 * Will Message
	 * User Name
	 * Password
	 * 
	 * Response
	 * The server sends a CONNACK message in response to a CONNECT message from a client.
	 * If the server does not receive a CONNECT message within a reasonable amount of time after the TCP/IP connection is established, 
	 * the server should close the connection.
	 * 
	 * If the client does not receive a CONNACK message from the server within a reasonable amount of time, the client should close 
	 * the TCP/IP socket connection, and restart the session by opening a new socket to the server and issuing a CONNECT message.
	 * 
	 * In both of these scenarios, a "reasonable" amount of time depends on the type of application and the communications infrastructure.
	 * 
	 * If a client with the same Client ID is already connected to the server, the "older" client must be disconnected by the server 
	 * before completing the CONNECT flow of the new client.
	 * 
	 * If the client sends an invalid CONNECT message, the server should close the connection. This includes CONNECT messages that 
	 * provide invalid Protocol Name or Protocol Version Numbers. If the server can parse enough of the CONNECT message to determine that 
	 * an invalid protocol has been requested, it may try to send a CONNACK containing the "Connection Refused: unacceptable protocol version" 
	 * code before dropping the connection.
	 * 
	 */
	import flash.utils.ByteArray;

	public class ConnectMessage extends MQTTMessage
	{
		public function ConnectMessage(username:String='',password:String='',clientid:String='',will:Object=null, keepalive:int=10,clean:int=1)
		{
			super(MQTTMessage.CONNECT);
			
			varHead = new ByteArray();
			varHead.writeByte(0x00); //0
			varHead.writeByte(0x06); //6
			varHead.writeByte(0x4d); //M
			varHead.writeByte(0x51); //Q
			varHead.writeByte(0x49); //I
			varHead.writeByte(0x73); //S
			varHead.writeByte(0x64); //D
			varHead.writeByte(0x70); //P
			varHead.writeByte(0x03); //Protocol version = 3
				
			var type:int = 0;
			if( clean ) type += 2;
			if( will )
			{
				type += 4;
				type += will['qos'] << 3;
				if( will['retain'] ) type += 32;
			}
			
			if( username ) type += 128;
			if( password ) type += 64;
			
			varHead.writeByte( type ); 				//Clean session only
			varHead.writeByte( keepalive >> 8 ); 	//Keepalive MSB
			varHead.writeByte( keepalive & 0xff ); 	//Keepaliave LSB = 60
			
			payLoad = new ByteArray();
			//payload
			writeString(payLoad, clientid);
			writeString(payLoad, username?username:"");
			writeString(payLoad, password?password:"");
			
			this.writeBytes(varHead);
			this.writeBytes(payLoad);
			
			this.position = 1;
			this.writeByte( varHead.length + payLoad.length );
		}
		
		override public function serialize():void
		{
			super.serialize();
			
			this.readBytes(varHead, 0 , 12);
			this.readBytes(payLoad);
			
			this.position = 1;
			this.writeByte(varHead.length + payLoad.length);
		}
	}
}