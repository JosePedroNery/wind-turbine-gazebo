// generated from rosidl_generator_cpp/resource/idl__traits.hpp.em
// with input from geographic_msgs:srv/GetRoutePlan.idl
// generated code does not contain a copyright notice

#ifndef GEOGRAPHIC_MSGS__SRV__DETAIL__GET_ROUTE_PLAN__TRAITS_HPP_
#define GEOGRAPHIC_MSGS__SRV__DETAIL__GET_ROUTE_PLAN__TRAITS_HPP_

#include <stdint.h>

#include <sstream>
#include <string>
#include <type_traits>

#include "geographic_msgs/srv/detail/get_route_plan__struct.hpp"
#include "rosidl_runtime_cpp/traits.hpp"

// Include directives for member types
// Member 'network'
// Member 'start'
// Member 'goal'
#include "unique_identifier_msgs/msg/detail/uuid__traits.hpp"

namespace geographic_msgs
{

namespace srv
{

inline void to_flow_style_yaml(
  const GetRoutePlan_Request & msg,
  std::ostream & out)
{
  out << "{";
  // member: network
  {
    out << "network: ";
    to_flow_style_yaml(msg.network, out);
    out << ", ";
  }

  // member: start
  {
    out << "start: ";
    to_flow_style_yaml(msg.start, out);
    out << ", ";
  }

  // member: goal
  {
    out << "goal: ";
    to_flow_style_yaml(msg.goal, out);
  }
  out << "}";
}  // NOLINT(readability/fn_size)

inline void to_block_style_yaml(
  const GetRoutePlan_Request & msg,
  std::ostream & out, size_t indentation = 0)
{
  // member: network
  {
    if (indentation > 0) {
      out << std::string(indentation, ' ');
    }
    out << "network:\n";
    to_block_style_yaml(msg.network, out, indentation + 2);
  }

  // member: start
  {
    if (indentation > 0) {
      out << std::string(indentation, ' ');
    }
    out << "start:\n";
    to_block_style_yaml(msg.start, out, indentation + 2);
  }

  // member: goal
  {
    if (indentation > 0) {
      out << std::string(indentation, ' ');
    }
    out << "goal:\n";
    to_block_style_yaml(msg.goal, out, indentation + 2);
  }
}  // NOLINT(readability/fn_size)

inline std::string to_yaml(const GetRoutePlan_Request & msg, bool use_flow_style = false)
{
  std::ostringstream out;
  if (use_flow_style) {
    to_flow_style_yaml(msg, out);
  } else {
    to_block_style_yaml(msg, out);
  }
  return out.str();
}

}  // namespace srv

}  // namespace geographic_msgs

namespace rosidl_generator_traits
{

[[deprecated("use geographic_msgs::srv::to_block_style_yaml() instead")]]
inline void to_yaml(
  const geographic_msgs::srv::GetRoutePlan_Request & msg,
  std::ostream & out, size_t indentation = 0)
{
  geographic_msgs::srv::to_block_style_yaml(msg, out, indentation);
}

[[deprecated("use geographic_msgs::srv::to_yaml() instead")]]
inline std::string to_yaml(const geographic_msgs::srv::GetRoutePlan_Request & msg)
{
  return geographic_msgs::srv::to_yaml(msg);
}

template<>
inline const char * data_type<geographic_msgs::srv::GetRoutePlan_Request>()
{
  return "geographic_msgs::srv::GetRoutePlan_Request";
}

template<>
inline const char * name<geographic_msgs::srv::GetRoutePlan_Request>()
{
  return "geographic_msgs/srv/GetRoutePlan_Request";
}

template<>
struct has_fixed_size<geographic_msgs::srv::GetRoutePlan_Request>
  : std::integral_constant<bool, has_fixed_size<unique_identifier_msgs::msg::UUID>::value> {};

template<>
struct has_bounded_size<geographic_msgs::srv::GetRoutePlan_Request>
  : std::integral_constant<bool, has_bounded_size<unique_identifier_msgs::msg::UUID>::value> {};

template<>
struct is_message<geographic_msgs::srv::GetRoutePlan_Request>
  : std::true_type {};

}  // namespace rosidl_generator_traits

// Include directives for member types
// Member 'plan'
#include "geographic_msgs/msg/detail/route_path__traits.hpp"

namespace geographic_msgs
{

namespace srv
{

inline void to_flow_style_yaml(
  const GetRoutePlan_Response & msg,
  std::ostream & out)
{
  out << "{";
  // member: success
  {
    out << "success: ";
    rosidl_generator_traits::value_to_yaml(msg.success, out);
    out << ", ";
  }

  // member: status
  {
    out << "status: ";
    rosidl_generator_traits::value_to_yaml(msg.status, out);
    out << ", ";
  }

  // member: plan
  {
    out << "plan: ";
    to_flow_style_yaml(msg.plan, out);
  }
  out << "}";
}  // NOLINT(readability/fn_size)

inline void to_block_style_yaml(
  const GetRoutePlan_Response & msg,
  std::ostream & out, size_t indentation = 0)
{
  // member: success
  {
    if (indentation > 0) {
      out << std::string(indentation, ' ');
    }
    out << "success: ";
    rosidl_generator_traits::value_to_yaml(msg.success, out);
    out << "\n";
  }

  // member: status
  {
    if (indentation > 0) {
      out << std::string(indentation, ' ');
    }
    out << "status: ";
    rosidl_generator_traits::value_to_yaml(msg.status, out);
    out << "\n";
  }

  // member: plan
  {
    if (indentation > 0) {
      out << std::string(indentation, ' ');
    }
    out << "plan:\n";
    to_block_style_yaml(msg.plan, out, indentation + 2);
  }
}  // NOLINT(readability/fn_size)

inline std::string to_yaml(const GetRoutePlan_Response & msg, bool use_flow_style = false)
{
  std::ostringstream out;
  if (use_flow_style) {
    to_flow_style_yaml(msg, out);
  } else {
    to_block_style_yaml(msg, out);
  }
  return out.str();
}

}  // namespace srv

}  // namespace geographic_msgs

namespace rosidl_generator_traits
{

[[deprecated("use geographic_msgs::srv::to_block_style_yaml() instead")]]
inline void to_yaml(
  const geographic_msgs::srv::GetRoutePlan_Response & msg,
  std::ostream & out, size_t indentation = 0)
{
  geographic_msgs::srv::to_block_style_yaml(msg, out, indentation);
}

[[deprecated("use geographic_msgs::srv::to_yaml() instead")]]
inline std::string to_yaml(const geographic_msgs::srv::GetRoutePlan_Response & msg)
{
  return geographic_msgs::srv::to_yaml(msg);
}

template<>
inline const char * data_type<geographic_msgs::srv::GetRoutePlan_Response>()
{
  return "geographic_msgs::srv::GetRoutePlan_Response";
}

template<>
inline const char * name<geographic_msgs::srv::GetRoutePlan_Response>()
{
  return "geographic_msgs/srv/GetRoutePlan_Response";
}

template<>
struct has_fixed_size<geographic_msgs::srv::GetRoutePlan_Response>
  : std::integral_constant<bool, false> {};

template<>
struct has_bounded_size<geographic_msgs::srv::GetRoutePlan_Response>
  : std::integral_constant<bool, false> {};

template<>
struct is_message<geographic_msgs::srv::GetRoutePlan_Response>
  : std::true_type {};

}  // namespace rosidl_generator_traits

namespace rosidl_generator_traits
{

template<>
inline const char * data_type<geographic_msgs::srv::GetRoutePlan>()
{
  return "geographic_msgs::srv::GetRoutePlan";
}

template<>
inline const char * name<geographic_msgs::srv::GetRoutePlan>()
{
  return "geographic_msgs/srv/GetRoutePlan";
}

template<>
struct has_fixed_size<geographic_msgs::srv::GetRoutePlan>
  : std::integral_constant<
    bool,
    has_fixed_size<geographic_msgs::srv::GetRoutePlan_Request>::value &&
    has_fixed_size<geographic_msgs::srv::GetRoutePlan_Response>::value
  >
{
};

template<>
struct has_bounded_size<geographic_msgs::srv::GetRoutePlan>
  : std::integral_constant<
    bool,
    has_bounded_size<geographic_msgs::srv::GetRoutePlan_Request>::value &&
    has_bounded_size<geographic_msgs::srv::GetRoutePlan_Response>::value
  >
{
};

template<>
struct is_service<geographic_msgs::srv::GetRoutePlan>
  : std::true_type
{
};

template<>
struct is_service_request<geographic_msgs::srv::GetRoutePlan_Request>
  : std::true_type
{
};

template<>
struct is_service_response<geographic_msgs::srv::GetRoutePlan_Response>
  : std::true_type
{
};

}  // namespace rosidl_generator_traits

#endif  // GEOGRAPHIC_MSGS__SRV__DETAIL__GET_ROUTE_PLAN__TRAITS_HPP_
