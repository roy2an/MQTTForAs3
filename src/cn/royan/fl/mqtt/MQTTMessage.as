package cn.royan.fl.mqtt
{
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	
	public class MQTTMessage extends ByteArray
	{
		/* Message types */
		public static const CONNECT:uint 		= 0x10;
		public static const CONNACK:uint 		= 0x20;
		public static const PUBLISH:uint 		= 0x30;
		public static const PUBACK:uint 		= 0x40;
		public static const PUBREC:uint 		= 0x50;
		public static const PUBREL:uint 		= 0x60;
		public static const PUBCOMP:uint 		= 0x70;
		public static const SUBSCRIBE:uint 	= 0x80;
		public static const SUBACK:uint 		= 0x90;
		public static const UNSUBSCRIBE:uint 	= 0xA0;
		public static const UNSUBACK:uint 	= 0xB0;
		public static const PINGREQ:uint 		= 0xC0;
		public static const PINGRESP:uint 	= 0xD0;
		public static const DISCONNECT:uint 	= 0xE0;
		
		protected var type:uint;
		protected var dup:int;
		protected var qos:int;
		protected var retain:int;
		protected var remainingLength:int;
		
		protected var fixHead:ByteArray;
		protected var varHead:ByteArray;
		protected var payLoad:ByteArray;
		
		public function MQTTMessage(type:uint)
		{
			this.position = 0;
			this.writeByte( type );
			this.writeByte( 0x00 );
		}
		
		public function readType():uint
		{
			this.position=0;
			return this.readUnsignedByte() & 0xF0;
		}
		
		public function readDUP():uint
		{
			this.position=0;
			return this.readUnsignedByte() >> 3 & 0x01;
		}
		
		public function readQoS():uint
		{
			this.position=0;
			return this.readUnsignedByte() >> 1 & 0x03;
		}
		
		public function readRETAIN():uint
		{
			this.position=0;
			return this.readUnsignedByte() & 0x01;
		}
		
		public function readRemainingLength():uint
		{
			this.position = 1;
			return this.readUnsignedByte();
		}
		
		public function readFixHead():ByteArray
		{
			return fixHead;
		}
		
		public function readVarHead():ByteArray
		{
			return varHead;
		}
		
		public function readPayLoad():ByteArray
		{
			return payLoad;
		}
		
		public function serialize():void
		{
			fixHead = new ByteArray();
			varHead = new ByteArray();
			payLoad = new ByteArray();
			
			this.position = 0;
			this.readBytes(fixHead, 0, 2);
		}
		
		public static function readFromBytes(input:IDataInput):MQTTMessage
		{
			var type:uint = input.readUnsignedByte();
			var remainingLength:int = input.readUnsignedByte();
			var message:MQTTMessage;
			switch( type ){
				case MQTTMessage.CONNECT:
					message = new ConnectMessage();
					break;
				case MQTTMessage.CONNACK:
					message = new ConnackMessage();
					break;
				case MQTTMessage.PUBLISH:
					message = new PublishMessage();
					break;
				case MQTTMessage.PUBACK:
					message = new PubackMessage();
					break;
				case MQTTMessage.PUBREC:
					message = new PubrecMessage();
					break;
				case MQTTMessage.PUBREL:
					message = new PubrelMessage();
					break;
				case MQTTMessage.PUBCOMP:
					message = new PubcompMessage();
					break;
				case MQTTMessage.SUBSCRIBE:
					message = new SubscribeMessage();
					break;
				case MQTTMessage.SUBACK:
					message = new SubackMessage();
					break;
				case MQTTMessage.UNSUBSCRIBE:
					message = new UnsubscribeMessage();
					break;
				case MQTTMessage.UNSUBACK:
					message = new UnsubackMessage();
					break;
				case MQTTMessage.PINGREQ:
					message = new PingreqMessage();
					break;
				case MQTTMessage.PINGRESP:
					message = new PingrespMessage();
					break;
				case MQTTMessage.DISCONNECT:
					message = new DisconnectMessage();
					break;
			}
			if( message ){
				input.readBytes(message, 2, remainingLength);
				message.serialize();
			}
			return message;
		}
		
		protected function writeString(bytes:ByteArray, str:String):void
		{
			var len:int = str.length;
			var msb:int = len >>8;
			var lsb:int = len % 256;
			bytes.writeByte(msb);
			bytes.writeByte(lsb);
			bytes.writeMultiByte(str, 'utf-8');
		}
	}
}