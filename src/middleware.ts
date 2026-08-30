import { withAuth } from "next-auth/middleware";

export default withAuth({
  pages: {
    signIn: "/login",
  },
});

export const config = {
  matcher: [
    "/dashboard/:path*",
    "/curriculum/:path*",
    "/skill-tree/:path*",
    "/resources/:path*",
    "/bookmarks/:path*",
    "/profile/:path*",
    "/settings/:path*",
    "/api/user/:path*",
    "/api/progress/:path*",
    "/api/notes/:path*",
    "/api/skills/:path*",
  ],
};
