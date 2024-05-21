import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { PreviewComponent } from './preview/preview.component';
import { AboutComponent } from './about/about.component';
import { AuthGuard } from './auth/auth.guard';
import { DownloadComponent } from './download/download.component';


const routes: Routes = [
  {
    path: '',
    pathMatch: 'full',
    redirectTo: 'preview',
  },
  {
    path: 'preview',              //用户访问/preview时,打开PreviewComponent
    component: PreviewComponent,  
    canActivate: [AuthGuard]      //路由守卫,打开PreviewComponent会用AuthCuard检查认证信息
  },
  {
    path: 'config',
    loadChildren: () => import('./config/config.module').then(mod => mod.ConfigModule),
    canLoad: [AuthGuard]
  },
  {
    path: 'about',
    component: AboutComponent
  },
  {
    path: 'download',
    component: DownloadComponent,
    canActivate: [AuthGuard]
  },
  {
    path: 'face',
    //
    loadChildren: () => import('./face/face.module').then(mod => mod.FaceModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'face-manage',
    loadChildren: () => import('./face-manage/face-manage.module').then(mod => mod.FaceManageModule),
    canActivate: [AuthGuard]
  },
  {
    path: 'face-para',
    loadChildren: () => import('./face-para/face-para.module').then(mod => mod.FaceParaModule),
    canActivate: [AuthGuard]
  },
];

@NgModule({
  imports: [RouterModule.forRoot( //全局
    routes,
    // { enableTracing: true }
  )],
  exports: [RouterModule]
})
export class AppRoutingModule { }
