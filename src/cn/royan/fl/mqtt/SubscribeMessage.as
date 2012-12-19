package cn.royan.fl.mqtt
{
	public class SubscribeMessage extends MQTTMessage
	{
		public function SubscribeMessage(topics:Array=null,qoss:Array=null,qos:int=0)
		{
			super(MQTTMessage.SUBSCRIBE);
		}
		
		override public function serialize():void
		{
			super.serialize();
			
			this.readBytes(varHead, 0 , 2);
			this.readBytes(payLoad);
			
			this.position = 1;
			this.writeByte(varHead.length + payLoad.length);
		}
	}
}