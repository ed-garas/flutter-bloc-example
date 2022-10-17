case $1 in

  watch)
    flutter pub run build_runner watch --delete-conflicting-outputs
    ;;

  build)
    flutter pub run build_runner build --delete-conflicting-outputs
    ;;

  *)
    echo -n "use watch or build"
    ;;
esac
