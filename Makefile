get-pub:
	@echo "getting pubs"
	flutter pub get


brunner:
	@echo "launching build runner"
	flutter pub run build_runner build --delete-conflicting-outputs


clean-and-run:
	@echo "cleaning and getting pub"
	flutter clean && flutter pub get


appbundle:
	@echo "build bundle for release"
	flutter clean && flutter build appbundle

apkbundle:
	@echo "building apk for release"
	flutter clean && flutter build apk --release


refresh:
	@echo "refreshing packages"
	flutter pub get