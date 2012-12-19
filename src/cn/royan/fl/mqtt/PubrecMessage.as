package cn.royan.fl.mqtt
{
	/**
	 * 
	 * Fixed header

The table below shows the fixed header format.

bit	7	6	5	4	3	2	1	0
byte 1	Message Type (5)	DUP flag	QoS level	RETAIN
0	1	0	1	x	x	x	x
byte 2	Remaining Length (2)
0	0	0	0	0	0	1	0
QoS level
Not used.
DUP flag
Not used.
RETAIN flag
Not used.
Remaining Length field
The length of the variable header (2 bytes). It can be a multibyte field.
Variable header

The variable header contains the Message ID for the acknowledged PUBLISH. The table below shows the format of the variable header.

bit	7	6	5	4	3	2	1	0
byte 1	Message ID MSB
byte 2	Message ID LSB
Payload

There is no payload.

Actions

When it receives a PUBREC message, the recipient sends a PUBREL message to the sender with the same Message ID as the PUBREC message.
	 */
	public class PubrecMessage extends MQTTMessage
	{
		protected var msgid:int;
		
		public function PubrecMessage(msgid:int=0)
		{
			super(MQTTMessage.PUBREC);
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