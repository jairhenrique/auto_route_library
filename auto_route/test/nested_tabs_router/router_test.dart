import 'package:auto_route/auto_route.dart';
import 'package:flutter_test/flutter_test.dart';

import '../router_test_utils.dart';
import 'router.dart';

// lazy way to test different tab types
var tabsType = 'IndexedStack';

void main() {
  tabsType = 'IndexedStack';
  tabsType = 'PageView';
  tabsType = 'TabBar';
  runTest();
}

void runTest() {
  late AppRouter router;
  setUp(() => router = AppRouter());
  testWidgets(
    'Initializing router App should present FirstRoute/Tab1Route',
        (WidgetTester tester) async {
      await pumpRouterApp(tester, router);
      expectTopPage(router, Tab1Route.name);
      expect(router.urlState.url, '/tab1');
    },
  );

  testWidgets(
    'Switching active index to 1 should present FirstRoute/Tab2Route/Tab2Nested1Route',
        (WidgetTester tester) async {
      await pumpRouterApp(tester, router);
      final tabsRouter = router.innerRouterOf<TabsRouter>(TabsHostRoute.name);
      expect(tabsRouter, isNotNull);
      tabsRouter!.setActiveIndex(1);
      await tester.pumpAndSettle();
      expectTopPage(router, Tab2Nested1Route.name);
      expect(router.urlState.url, '/tab2/tab2Nested1');
    },
  );

  testWidgets(
    'Switching active index to 2 should present FirstRoute/Tab3Route/Tab3Nested1Route',
        (WidgetTester tester) async {
      await pumpRouterApp(tester, router);
      final tabsRouter = router.innerRouterOf<TabsRouter>(TabsHostRoute.name);
      expect(tabsRouter, isNotNull);
      tabsRouter!.setActiveIndex(2);
      await tester.pumpAndSettle();
      expectTopPage(router, Tab3Nested1Route.name);
      expect(router.urlState.url, '/tab3/tab3Nested1');
    },
  );

  testWidgets(
    'Navigating to Tab2Route using root router should present FirstRoute/Tab2Route/Tab2Nested1Route',
        (WidgetTester tester) async {
      await pumpRouterApp(tester, router);
      router.navigate(const Tab2Route());
      await tester.pumpAndSettle();
      expectTopPage(router, Tab2Nested1Route.name);
      expect(router.urlState.url, '/tab2/tab2Nested1');
    },
  );

  testWidgets(
    'Navigating to Tab3Route using root router should present FirstRoute/Tab3Route/Tab3Nested1Route',
        (WidgetTester tester) async {
      await pumpRouterApp(tester, router);
      router.navigate(const Tab3Route());
      await tester.pumpAndSettle();
      expectTopPage(router, Tab3Nested1Route.name);
      expect(router.urlState.url, '/tab3/tab3Nested1');
    },
  );

  testWidgets(
    'Navigating to Tab3Route with children [Tab3Nested2Route] using root router should present FirstRoute/Tab3Route/Tab3Nested2Route',
        (WidgetTester tester) async {
      await pumpRouterApp(tester, router);
      router.navigate(const Tab3Route(children: [Tab3Nested2Route()]));
      await tester.pumpAndSettle();
      expectTopPage(router, Tab3Nested2Route.name);
      expect(router.urlState.url, '/tab3/tab3Nested2');
    },
  );

  testWidgets(
    'Navigating from un-maintainedState route FirstRoute/Tab3Route/Tab3Nested2Route and going back should present FirstRoute/Tab3Route/Tab3Nested1Route',
        (WidgetTester tester) async {
      await pumpRouterApp(tester, router);
      router.navigate(const Tab3Route(children: [Tab3Nested2Route()]));
      await tester.pumpAndSettle();
      expectTopPage(router, Tab3Nested2Route.name);
      router.navigate(const Tab1Route());
      await tester.pumpAndSettle();
      router.navigate(const Tab3Route());
      await tester.pumpAndSettle();
      expect(router.urlState.url, '/tab3/tab3Nested1');
    },
  );

  testWidgets(
    'Initializing router App with deep-link "/tab3/tab3Nested2" should present FirstRoute/Tab3Route/Tab3Nested2Route',
        (WidgetTester tester) async {
      await pumpRouterApp(tester, router, initialLink: '/tab3/tab3Nested2');
      expectTopPage(router, Tab3Nested2Route.name);
      expect(router.urlState.url, '/tab3/tab3Nested2');
    },
  );

  testWidgets(
    'Initializing router App with invalid deep-link should present FirstRoute/Tab1Route',
        (WidgetTester tester) async {
      await pumpRouterApp(tester, router, initialLink: '/invalid-deep-link');
      expectTopPage(router, Tab1Route.name);
      expect(router.urlState.url, '/tab1');
    },
  );
}