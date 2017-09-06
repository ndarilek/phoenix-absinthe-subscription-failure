export default ({store, redirect, route}) => {
  if (!store.getters["auth/isAuthenticated"])
    return redirect("/login", {redirect: route.fullPath})
}
