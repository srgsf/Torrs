package api

import (
	"torrsru/web/api/pages"
	"torrsru/web/api/tmdb"

	"github.com/gin-gonic/gin"
)

func SetRoutes(r *gin.Engine) {
	r.GET("/", pages.MainPage)
	//r.GET("/robots.txt", pages.RobotsPage)
	r.GET("/search", pages.Search)
	r.GET("/ping", pages.Ping)
	r.GET("/tmdb/*path", tmdb.TMDBAPI)
	r.GET("/tmdbimg/*path", tmdb.TMDBIMG)
}
