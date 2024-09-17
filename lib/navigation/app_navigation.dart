import 'package:cjowner/models/branch.dart';
import 'package:cjowner/models/customer.dart';
import 'package:cjowner/models/manageCustomer.dart';
import 'package:cjowner/models/manage_salesrep.dart';
import 'package:cjowner/models/salesRep.dart';
import 'package:cjowner/models/stockitemmodel.dart';
import 'package:cjowner/services/auth/auth_service.dart';
import 'package:cjowner/views/Auth/login_view.dart';
import 'package:cjowner/views/Items/ItemsIn/AddStock/addCartItems_view.dart';
import 'package:cjowner/views/Items/ItemsIn/AddStock/addItem_view.dart';
import 'package:cjowner/views/Items/ItemsIn/PricingItems/EditPricingItem_view.dart';
import 'package:cjowner/views/Items/ItemsIn/PricingItems/pricingItemStart_view.dart';
import 'package:cjowner/views/Items/ItemsIn/PricingItems/pricingItem_view.dart';
import 'package:cjowner/views/Items/ItemsIn/Registeritems/registerItems_view.dart';
import 'package:cjowner/views/Items/ItemsIn/VerifyItems/updateDetailsRejectItems_view.dart';
import 'package:cjowner/views/Items/ItemsIn/VerifyItems/verifyItem_view.dart';
import 'package:cjowner/views/Items/ItemsIn/VerifyItems/verifyItems_view.dart';
import 'package:cjowner/views/Items/ItemsIn/itemsIn_view.dart';
import 'package:cjowner/views/Items/ViewItems/manageItems_view.dart';
import 'package:cjowner/views/Items/items_view.dart';
import 'package:cjowner/views/Items/PreOrders/preOrders_view.dart';
import 'package:cjowner/views/Items/ViewItems/viewItems_view.dart';
import 'package:cjowner/views/Manage/Branch/addBranch_view.dart';
import 'package:cjowner/views/Manage/Branch/branchs_view.dart';
import 'package:cjowner/views/Manage/Branch/manageBranch_view.dart';
import 'package:cjowner/views/Manage/Customers/addCustomer_view.dart';
import 'package:cjowner/views/Manage/Customers/customers_view.dart';
import 'package:cjowner/views/Manage/Customers/manageCustomers_view.dart';
import 'package:cjowner/views/Manage/SalesReps/addSalesReps_view.dart';
import 'package:cjowner/views/Manage/SalesReps/manageSalesReps_view.dart';
import 'package:cjowner/views/Manage/SalesReps/salesReps_view.dart';
import 'package:cjowner/views/Manage/manage_view.dart';
import 'package:cjowner/views/Reports/DailyReports/dailyReports_view.dart';
import 'package:cjowner/views/Reports/MonthlyReports/monthlyReports_view.dart';
import 'package:cjowner/views/Reports/SalesRepsReports/SalesRepsReport_view.dart';
import 'package:cjowner/views/Reports/SalesRepsReports/salesRepsReports_view.dart';
import 'package:cjowner/views/Reports/reports_view.dart';
import 'package:cjowner/views/maintenance/maintenance_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cjowner/views/home/home_view.dart';
import 'package:cjowner/views/wrapper/main_wrapper.dart';

class AppNavigation {
  AppNavigation._();

  static String initial = "/home";

  // Private navigators
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorHome =
      GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  static final _shellNavigatorItems =
      GlobalKey<NavigatorState>(debugLabel: 'shellItems');
  static final _shellNavigatorManage =
      GlobalKey<NavigatorState>(debugLabel: 'shellManage');
  static final _shellNavigatorReports =
      GlobalKey<NavigatorState>(debugLabel: 'shellReports');

  // GoRouter configuration
  static final GoRouter router = GoRouter(
    initialLocation: initial,
    redirect: (context, state) async {
      final String? token = await AuthService.getToken();
      final bool isAuthenticated = token != null;
      final bool isMaintenanceMode = await AuthService.checkMaintenanceStatus();

      if (isMaintenanceMode) {
        return "/maintenance";
      } else if (isAuthenticated) {
        return null;
      } else if (!isAuthenticated) {
        return "/login";
      } else {
        return null;
      }
    },
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    routes: [
      /// Login Route
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (BuildContext context, GoRouterState state) =>
            const LoginView(),
      ),
      GoRoute(
        path: '/maintenance',
        name: 'maintenance',
        builder: (BuildContext context, GoRouterState state) =>
            const MaintenanceView(),
      ),
      /// MainWrapper
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(
            navigationShell: navigationShell,
          );
        },
        branches: <StatefulShellBranch>[
          /// Branch Home
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHome,
            routes: <RouteBase>[
              GoRoute(
                path: "/home",
                name: "home",
                builder: (BuildContext context, GoRouterState state) =>
                    const HomeView(),
              ),
            ],
          ),

          /// Branch items
          StatefulShellBranch(
            navigatorKey: _shellNavigatorItems,
            routes: <RouteBase>[
              GoRoute(
                path: "/items",
                name: "items",
                builder: (BuildContext context, GoRouterState state) =>
                    const ItemsView(),
                routes: [
                  GoRoute(
                      path: "itemsIn",
                      name: "itemsIn",
                      pageBuilder: (context, state) {
                        return CustomTransitionPage<void>(
                          key: state.pageKey,
                          child: const ItemsinView(),
                          transitionsBuilder: (
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ) =>
                              FadeTransition(opacity: animation, child: child),
                        );
                      },
                      routes: [
                        GoRoute(
                            path: "addStock",
                            name: "addStock",
                            pageBuilder: (context, state) {
                              return CustomTransitionPage<void>(
                                key: state.pageKey,
                                child: const AdditemView(),
                                transitionsBuilder: (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) =>
                                    FadeTransition(
                                        opacity: animation, child: child),
                              );
                            },
                            routes: [
                              GoRoute(
                                  path: "addItem",
                                  name: "addItem",
                                  pageBuilder: (context, state) {
                                    return CustomTransitionPage<void>(
                                      key: state.pageKey,
                                      child: const AdditemView(),
                                      transitionsBuilder: (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                        child,
                                      ) =>
                                          FadeTransition(
                                              opacity: animation, child: child),
                                    );
                                  },
                                  routes: [
                                    GoRoute(
                                      path: "addCartItems",
                                      name: "addCartItems",
                                      pageBuilder: (context, state) {
                                        return CustomTransitionPage<void>(
                                          key: state.pageKey,
                                          child: const AddcartitemsView(),
                                          transitionsBuilder: (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                            child,
                                          ) =>
                                              FadeTransition(
                                                  opacity: animation,
                                                  child: child),
                                        );
                                      },
                                    )
                                  ])
                            ]),
                        GoRoute(
                            path: "verifyItems",
                            name: "verifyItems",
                            pageBuilder: (context, state) {
                              return CustomTransitionPage<void>(
                                key: state.pageKey,
                                child: const VerifyitemsView(),
                                transitionsBuilder: (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) =>
                                    FadeTransition(
                                        opacity: animation, child: child),
                              );
                            },
                            routes: [
                              GoRoute(
                                  path: "verifyItem",
                                  name: "verifyItem",
                                  pageBuilder: (context, state) {
                                    final Map<String, dynamic> extra =
                                        state.extra as Map<String, dynamic>;
                                    final List<Map<String, dynamic>> items =
                                        List<Map<String, dynamic>>.from(
                                            extra['items']);
                                    final String stockId = extra['stockId']
                                        as String; // Retrieve `stockId` here
                                    return CustomTransitionPage<void>(
                                      key: state.pageKey,
                                      child: VerifyitemView(
                                        items: items,
                                        stockId: stockId,
                                      ),
                                      transitionsBuilder: (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                        child,
                                      ) =>
                                          FadeTransition(
                                              opacity: animation, child: child),
                                    );
                                  },
                                  routes: [
                                    GoRoute(
                                      path: "updatedetailsrejectitemsView",
                                      name: "updatedetailsrejectitemsView",
                                      pageBuilder: (context, state) {
                                        return CustomTransitionPage<void>(
                                          key: state.pageKey,
                                          child:
                                              const UpdatedetailsrejectitemsView(),
                                          transitionsBuilder: (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                            child,
                                          ) =>
                                              FadeTransition(
                                                  opacity: animation,
                                                  child: child),
                                        );
                                      },
                                    )
                                  ])
                            ]),
                        GoRoute(
                            path: "pricingItem",
                            name: "pricingItem",
                            pageBuilder: (context, state) {
                              return CustomTransitionPage<void>(
                                key: state.pageKey,
                                child: const PricingitemView(),
                                transitionsBuilder: (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) =>
                                    FadeTransition(
                                        opacity: animation, child: child),
                              );
                            },
                            routes: [
                              GoRoute(
                                path: "pricingItemstart",
                                name: "pricingItemstart",
                                pageBuilder: (context, state) {
                                  return CustomTransitionPage<void>(
                                    key: state.pageKey,
                                    child: const PricingitemstartView(),
                                    transitionsBuilder: (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) =>
                                        FadeTransition(
                                            opacity: animation, child: child),
                                  );
                                },
                              ),
                              GoRoute(
                                path: 'edit',
                                name: "editpricingItem",
                                builder: (context, state) {
                                  final StockItemmodel item =
                                      state.extra as StockItemmodel;
                                  return EditPricingItem(item: item);
                                },
                              ),
                            ]),
                        GoRoute(
                          path: "registerItems",
                          name: "registerItems",
                          pageBuilder: (context, state) {
                            return CustomTransitionPage<void>(
                              key: state.pageKey,
                              child: const RegisterItemsView(),
                              transitionsBuilder: (
                                context,
                                animation,
                                secondaryAnimation,
                                child,
                              ) =>
                                  FadeTransition(
                                      opacity: animation, child: child),
                            );
                          },
                        )
                      ]),
                  GoRoute(
                    path: "preOrders",
                    name: "preOrders",
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: const PreordersView(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) =>
                            FadeTransition(opacity: animation, child: child),
                      );
                    },
                  ),
                  GoRoute(
                      path: "viewItems",
                      name: "viewItems",
                      pageBuilder: (context, state) {
                        return CustomTransitionPage<void>(
                          key: state.pageKey,
                          child: const ViewitemsView(),
                          transitionsBuilder: (
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ) =>
                              FadeTransition(opacity: animation, child: child),
                        );
                      },
                      routes: [
                        GoRoute(
                          path: "manageItems",
                          name: "manageItems",
                          pageBuilder: (context, state) {
                            return CustomTransitionPage<void>(
                              key: state.pageKey,
                              child: const ManageitemsView(),
                              transitionsBuilder: (
                                context,
                                animation,
                                secondaryAnimation,
                                child,
                              ) =>
                                  FadeTransition(
                                      opacity: animation, child: child),
                            );
                          },
                        )
                      ]),
                ],
              ),
            ],
          ),

          /// Branch Manage
          StatefulShellBranch(
            navigatorKey: _shellNavigatorManage,
            routes: <RouteBase>[
              GoRoute(
                  path: "/manage",
                  name: "manage",
                  builder: (BuildContext context, GoRouterState state) =>
                      const ManageView(),
                  routes: [
                    GoRoute(
                        path: "salesReps",
                        name: "salesReps",
                        pageBuilder: (context, state) {
                          return CustomTransitionPage<void>(
                            key: state.pageKey,
                            child: const SalesrepsView(),
                            transitionsBuilder: (
                              context,
                              animation,
                              secondaryAnimation,
                              child,
                            ) =>
                                FadeTransition(
                                    opacity: animation, child: child),
                          );
                        },
                        routes: [
                          GoRoute(
                            path: "addsalesReps",
                            name: "addsalesReps",
                            pageBuilder: (context, state) {
                              return CustomTransitionPage<void>(
                                key: state.pageKey,
                                child: const AddsalesrepsView(),
                                transitionsBuilder: (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) =>
                                    FadeTransition(
                                        opacity: animation, child: child),
                              );
                            },
                          ),
                          GoRoute(
                            path: "manageSalesReps",
                            name: "manageSalesReps",
                            pageBuilder: (context, state) {
                              final ManageSalesRepModel rep =
                                  state.extra as ManageSalesRepModel;
                              return CustomTransitionPage<void>(
                                key: state.pageKey,
                                child: ManagesalesrepsView(salesRep: rep),
                                transitionsBuilder: (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) =>
                                    FadeTransition(
                                        opacity: animation, child: child),
                              );
                            },
                          )
                        ]),
                    GoRoute(
                        path: "branches",
                        name: "branches",
                        pageBuilder: (context, state) {
                          return CustomTransitionPage<void>(
                            key: state.pageKey,
                            child: const BranchsView(),
                            transitionsBuilder: (
                              context,
                              animation,
                              secondaryAnimation,
                              child,
                            ) =>
                                FadeTransition(
                                    opacity: animation, child: child),
                          );
                        },
                        routes: [
                          GoRoute(
                            path: "addBranch",
                            name: "addBranch",
                            pageBuilder: (context, state) {
                              return CustomTransitionPage<void>(
                                key: state.pageKey,
                                child: const AddbranchView(),
                                transitionsBuilder: (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) =>
                                    FadeTransition(
                                        opacity: animation, child: child),
                              );
                            },
                          ),
                          GoRoute(
                            path: "manageBranch",
                            name: "manageBranch",
                            pageBuilder: (context, state) {
                              final Map<String, dynamic> extra =
                                  state.extra as Map<String, dynamic>;
                              final String branchId = extra["branchId"];
                              final String branchName = extra["branchName"];
                              return CustomTransitionPage<void>(
                                key: state.pageKey,
                                child: ManagebranchView(
                                  branchId: branchId,
                                  branchName: branchName,
                                ),
                                transitionsBuilder: (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) =>
                                    FadeTransition(
                                        opacity: animation, child: child),
                              );
                            },
                          )
                        ]),
                    GoRoute(
                        path: "customers",
                        name: "customers",
                        pageBuilder: (context, state) {
                          return CustomTransitionPage<void>(
                            key: state.pageKey,
                            child: const CustomersView(),
                            transitionsBuilder: (
                              context,
                              animation,
                              secondaryAnimation,
                              child,
                            ) =>
                                FadeTransition(
                                    opacity: animation, child: child),
                          );
                        },
                        routes: [
                          GoRoute(
                            path: "addCustomers",
                            name: "addCustomers",
                            pageBuilder: (context, state) {
                              return CustomTransitionPage<void>(
                                key: state.pageKey,
                                child: const AddcustomerView(),
                                transitionsBuilder: (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) =>
                                    FadeTransition(
                                        opacity: animation, child: child),
                              );
                            },
                          ),
                          GoRoute(
                            path: "manageCustomers",
                            name: "manageCustomers",
                            pageBuilder: (context, state) {
                              final manageCustomer customer =
                                  state.extra as manageCustomer;
                              return CustomTransitionPage<void>(
                                key: state.pageKey,
                                child: ManagecustomersView(customer: customer),
                                transitionsBuilder: (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) =>
                                    FadeTransition(
                                        opacity: animation, child: child),
                              );
                            },
                          )
                        ]),
                  ]),
            ],
          ),

          /// Branch Reports
          StatefulShellBranch(
            navigatorKey: _shellNavigatorReports,
            routes: <RouteBase>[
              GoRoute(
                  path: "/reports",
                  name: "reports",
                  builder: (BuildContext context, GoRouterState state) =>
                      const ReportsView(),
                  routes: [
                    GoRoute(
                      path: "dailyReports",
                      name: "dailyReports",
                      pageBuilder: (context, state) {
                        return CustomTransitionPage<void>(
                          key: state.pageKey,
                          child: const DailyreportsView(),
                          transitionsBuilder: (
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ) =>
                              FadeTransition(opacity: animation, child: child),
                        );
                      },
                    ),
                    GoRoute(
                      path: "monthlyReports",
                      name: "monthlyReports",
                      pageBuilder: (context, state) {
                        return CustomTransitionPage<void>(
                          key: state.pageKey,
                          child: const MonthlyreportsView(),
                          transitionsBuilder: (
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ) =>
                              FadeTransition(opacity: animation, child: child),
                        );
                      },
                    ),
                    GoRoute(
                        path: "salesRepsReports",
                        name: "salesRepsReports",
                        pageBuilder: (context, state) {
                          return CustomTransitionPage<void>(
                            key: state.pageKey,
                            child: const SalesrepsreportsView(),
                            transitionsBuilder: (
                              context,
                              animation,
                              secondaryAnimation,
                              child,
                            ) =>
                                FadeTransition(
                                    opacity: animation, child: child),
                          );
                        },
                        routes: [
                          GoRoute(
                            path: "salesRepsReport",
                            name: "salesRepsReport",
                            pageBuilder: (context, state) {
                              return CustomTransitionPage<void>(
                                key: state.pageKey,
                                child: const SalesrepsreportView(),
                                transitionsBuilder: (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) =>
                                    FadeTransition(
                                        opacity: animation, child: child),
                              );
                            },
                          )
                        ])
                  ]),
            ],
          ),
        ],
      ),

      /// Player
      // GoRoute(
      //   parentNavigatorKey: _rootNavigatorKey,
      //   path: '/player',
      //   name: "Player",
      //   builder: (context, state) => PlayerView(
      //     key: state.pageKey,
      //   ),
      // )
    ],
  );
}
