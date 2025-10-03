// generated from rosidl_generator_cpp/resource/idl__traits.hpp.em
// with input from geographic_msgs:srv/GetGeographicMap.idl
// generated code does not contain a copyright notice

#ifndef GEOGRAPHIC_MSGS__SRV__DETAIL__GET_GEOGRAPHIC_MAP__TRAITS_HPP_
#define GEOGRAPHIC_MSGS__SRV__DETAIL__GET_GEOGRAPHIC_MAP__TRAITS_HPP_

#include <stdint.h>

#include <sstream>
#include <string>
#include <type_traits>

#include "geographic_msgs/srv/detail/get_geographic_map__struct.hpp"
#include "rosidl_runtime_cpp/traits.hpp"

// Include directives for member types
// Member 'bounds'
#include "geographic_msgs/msg/detail/bounding_box__traits.hpp"

namespace geographic_msgs
{

namespace srv
{

inline void to_flow_style_yaml(
  const GetGeographicMap_Request & msg,
  std::ostream & out)
{
  out << "{";
  // member: url
  {
    out << "url: ";
    rosidl_generator_traits::value_to_yaml(msg.url, out);
    out << ", ";
  }

  // member: bounds
  {
    out << "bounds: ";
    to_flow_style_yaml(msg.bounds, out);
  }
  out << "}";
}  // NOLINT(readability/fn_size)

inline void to_block_style_yaml(
  const GetGeographicMap_Request & msg,
  std::ostream & out, size_t indentation = 0)
{
  // member: url
  {
    if (indentation > 0) {
      out << std::string(indentation, ' ');
    }
    out << "url: ";
    rosidl_generator_traits::value_to_yaml(msg.url, out);
    out << "\n";
  }

  // member: bounds
  {
    if (indentation > 0) {
      out << std::string(indentation, ' ');
    }
    out << "bounds:\n";
    to_block_style_yaml(msg.bounds, out, indentation + 2);
  }
}  // NOLINT(readability/fn_size)

inline std::string to_yaml(const GetGeographicMap_Request & msg, bool use_flow_style = false)
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
  const geographic_msgs::srv::GetGeographicMap_Request & msg,
  std::ostream & out, size_t indentation = 0)
{
  geographic_msgs::srv::to_block_style_yaml(msg, out, indentation);
}

[[deprecated("use geographic_msgs::srv::to_yaml() instead")]]
inline std::string to_yaml(const geographic_msgs::srv::GetGeographicMap_Request & msg)
{
  return geographic_msgs::srv::to_yaml(msg);
}

template<>
inline const char * data_type<geographic_msgs::srv::GetGeographicMap_Request>()
{
  return "geographic_msgs::srv::GetGeographicMap_Request";
}

template<>
inline const char * name<geographic_msgs::srv::GetGeographicMap_Request>()
{
  return "geographic_msgs/srv/GetGeographicMap_Request";
}

template<>
struct has_fixed_size<geographic_msgs::srv::GetGeographicMap_Request>
  : std::integral_constant<bool, false> {};

template<>
struct has_bounded_size<geographic_msgs::srv::GetGeographicMap_Request>
  : std::integral_constant<bool, false> {};

template<>
struct is_message<geographic_msgs::srv::GetGeographicMap_Request>
  : std::true_type {};

}  // namespace rosidl_generator_traits

// Include directives for member types
// Member 'map'
#include "geographic_msgs/msg/detail/geographic_map__traits.hpp"

namespace geographic_msgs
{

namespace srv
{

inline void to_flow_style_yaml(
  const GetGeographicMap_Response & msg,
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

  // member: map
  {
    out << "map: ";
    to_flow_style_yaml(msg.map, out);
  }
  out << "}";
}  // NOLINT(readability/fn_size)

inline void to_block_style_yaml(
  const GetGeographicMap_Response & msg,
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

  // member: map
  {
    if (indentation > 0) {
      out << std::string(indentation, ' ');
    }
    out << "map:\n";
    to_block_style_yaml(msg.map, out, indentation + 2);
  }
}  // NOLINT(readability/fn_size)

inline std::string to_yaml(const GetGeographicMap_Response & msg, bool use_flow_style = false)
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
  const geographic_msgs::srv::GetGeographicMap_Response & msg,
  std::ostream & out, size_t indentation = 0)
{
  geographic_msgs::srv::to_block_style_yaml(msg, out, indentation);
}

[[deprecated("use geographic_msgs::srv::to_yaml() instead")]]
inline std::string to_yaml(const geographic_msgs::srv::GetGeographicMap_Response & msg)
{
  return geographic_msgs::srv::to_yaml(msg);
}

template<>
inline const char * data_type<geographic_msgs::srv::GetGeographicMap_Response>()
{
  return "geographic_msgs::srv::GetGeographicMap_Response";
}

template<>
inline const char * name<geographic_msgs::srv::GetGeographicMap_Response>()
{
  return "geographic_msgs/srv/GetGeographicMap_Response";
}

template<>
struct has_fixed_size<geographic_msgs::srv::GetGeographicMap_Response>
  : std::integral_constant<bool, false> {};

template<>
struct has_bounded_size<geographic_msgs::srv::GetGeographicMap_Response>
  : std::integral_constant<bool, false> {};

template<>
struct is_message<geographic_msgs::srv::GetGeographicMap_Response>
  : std::true_type {};

}  // namespace rosidl_generator_traits

namespace rosidl_generator_traits
{

template<>
inline const char * data_type<geographic_msgs::srv::GetGeographicMap>()
{
  return "geographic_msgs::srv::GetGeographicMap";
}

template<>
inline const char * name<geographic_msgs::srv::GetGeographicMap>()
{
  return "geographic_msgs/srv/GetGeographicMap";
}

template<>
struct has_fixed_size<geographic_msgs::srv::GetGeographicMap>
  : std::integral_constant<
    bool,
    has_fixed_size<geographic_msgs::srv::GetGeographicMap_Request>::value &&
    has_fixed_size<geographic_msgs::srv::GetGeographicMap_Response>::value
  >
{
};

template<>
struct has_bounded_size<geographic_msgs::srv::GetGeographicMap>
  : std::integral_constant<
    bool,
    has_bounded_size<geographic_msgs::srv::GetGeographicMap_Request>::value &&
    has_bounded_size<geographic_msgs::srv::GetGeographicMap_Response>::value
  >
{
};

template<>
struct is_service<geographic_msgs::srv::GetGeographicMap>
  : std::true_type
{
};

template<>
struct is_service_request<geographic_msgs::srv::GetGeographicMap_Request>
  : std::true_type
{
};

template<>
struct is_service_response<geographic_msgs::srv::GetGeographicMap_Response>
  : std::true_type
{
};

}  // namespace rosidl_generator_traits

#endif  // GEOGRAPHIC_MSGS__SRV__DETAIL__GET_GEOGRAPHIC_MAP__TRAITS_HPP_
