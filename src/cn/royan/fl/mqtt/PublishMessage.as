package cn.royan.fl.mqtt
{
	public class PublishMessage extends MQTTMessage
	{
		protected var msgid:int;
		
		public function PublishMessage(topic:String="",content:String="",qos:int=0)
		{
			super(MQTTMessage.PUBLISH);
		}
		
		override public function serialize():void
		{
			super.serialize();
			
			var index:int = (this.readUnsignedByte() << 8) + this.readUnsignedByte();//the length of variable header
			this.position = 2;
			this.readBytes(varHead, 0 , index + 4);
			this.readBytes(payLoad);
			
			this.position = 1;
			this.writeByte(varHead.length + payLoad.length);
		}
		
		public function readMessageID():int
		{
			return msgid;
		}
	}
}