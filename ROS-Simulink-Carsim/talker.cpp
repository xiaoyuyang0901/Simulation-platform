//talker.cpp
#include <stdio.h>
#include "ros/ros.h"
#include "geometry_msgs/Pose2D.h"
#include "std_msgs/Float64.h"

int main(int argc,char **argv)
{
    ros::init(argc,argv,"talker1");
    ros::NodeHandle n;
    ros::Publisher chatter_pub = n.advertise<geometry_msgs::Pose2D>("control",10);
    ros::Rate loop_rate(10);           
    float count = 0;
    while(ros::ok())
    {
        geometry_msgs::Pose2D msg;
        msg.x = count * 0.01;      // 油门开度
        msg.y = 0.5;               //方向盘扭矩 
        msg.theta = 0;             //刹车气缸的压强
        ROS_INFO("%f",msg.x);
        //printf("%f\n",msg.data);
        chatter_pub.publish(msg);
        ros::spinOnce();
        loop_rate.sleep();
        ++count;

        if (msg.x > 1)
        {
            count = 0;
        }
    }
    return 0;
}
