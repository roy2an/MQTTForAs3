package cn.royan.fl.mqtt
{
	/**
	 * 
	 * Fixed header
The table below shows the fixed header format.

bit	7	6	5	4	3	2	1	0
byte 1	Message Type (6)	DUP flag	QoS level	RETAIN
0	1	1	0	0	0	1	x
byte 2	Remaining Length (2)
0	0	0	0	0	0	1	0
QoS level
PUBREL messages use QoS level 1 as an acknowledgement is expected in the form of a PUBCOMP. Retries are handled in the same way as PUBLISH messages.

DUP flag
Set to zero (0). This means that the message is being sent for the first time. See DUP for more details.

RETAIN flag
Not used.
Remaining Length field
The length of the variable header (2 bytes). It can be a multibyte field.
Variable header

The variable header contains the same Message ID as the PUBREC message that is being acknowledged. The table below shows the format of the variable header.

bit	7	6	5	4	3	2	1	0
byte 1	Message ID MSB
byte 2	Message ID LSB
Payload

There is no payload.

Actions

When the server receives a PUBREL message from a publisher, the server makes the original message available to interested subscribers, and sends a PUBCOMP message with the same Message ID to the publisher. When a subscriber receives a PUBREL message from the server, the subscriber makes the message available to the subscribing application and sends a PUBCOMP message to the server.
	 */
	public class PubrelMessage extends MQTTMessage
	{
		protected var msgid:int;
		
		public function PubrelMessage(msgid:int=0)
		{
			super(MQTTMessage.PUBREL);
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