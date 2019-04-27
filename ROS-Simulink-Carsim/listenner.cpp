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
    ros::init(argc,argv,"listener1");
    ros::NodeHandle n;
    ros::Subscriber sub = n.subscribe("simulink_pose",1,chatterCallback);
    ros::spin();
    return 0;
}
