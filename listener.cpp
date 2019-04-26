//listenner.cpp
#include <stdio.h>
#include "ros/ros.h"
#include "geometry_msgs/Pose2D.h"
void chatterCallback(const geometry_msgs::Pose2D& msg)
{
    //ROS_INFO("I heard:[%f]",msg );
    ROS_INFO("I heard:",msg );
    printf("%f\n",msg.x);
    printf("%f\n",msg.y);
    printf("%f\n",msg.theta);
}
int main(int argc,char **argv)
{
    //名称初始化时要求唯一
    ros::init(argc,argv,"listener1");
    ros::NodeHandle n;

    //这里订阅的chatter必须与发布者一致
    ros::Subscriber sub = n.subscribe("simulink_pose",1,chatterCallback);

    //spin()是节点读取数据的消息响应循环
    ros::spin();
    return 0;
}

