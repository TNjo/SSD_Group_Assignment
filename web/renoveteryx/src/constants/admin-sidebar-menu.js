import DashboardIcon from "../assets/icons/dashboard.svg";
import ShippingIcon from "../assets/icons/shipping.svg";
import ProductIcon from "../assets/icons/product.svg";
import UserIcon from "../assets/icons/user.svg";

const admin_sidebar_menu = [
  {
    id: 1,
    icon: DashboardIcon,
    path: "/admin-home",
    title: "Dashboard",
  },
  {
    id: 2,
    icon: ProductIcon,
    path: "/admin-orders",
    title: "All Orders",
  },
  {
    id: 3,
    icon: ShippingIcon,
    path: "/admin-products",
    title: "My Orders",
  },
  {
    id: 4,
    icon: UserIcon,
    path: "/admin-profile",
    title: "My account",
  },
];

export default admin_sidebar_menu;
