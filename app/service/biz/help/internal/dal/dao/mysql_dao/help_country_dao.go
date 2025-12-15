/*
 * WARNING! All changes made in this file will be lost!
 *   Created from by 'dalgen'
 *
 * Copyright (c) 2024-present,  Teamgram Authors.
 *  All rights reserved.
 *
 * Author: teamgramio (teamgram.io@gmail.com)
 */

package mysql_dao

import (
	"context"

	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"github.com/teamgram/teamgram-server/app/service/biz/help/internal/dal/dataobject"

	"github.com/zeromicro/go-zero/core/logx"
)

type HelpCountryDAO struct {
	db *sqlx.DB
}

func NewHelpCountryDAO(db *sqlx.DB) *HelpCountryDAO {
	return &HelpCountryDAO{
		db: db,
	}
}

// SelectAll
// select id, hidden, iso2, default_name, name, country_code, prefixes, patterns, created_at, updated_at from help_country where hidden = 0 order by id
func (dao *HelpCountryDAO) SelectAll(ctx context.Context) (rList []dataobject.HelpCountryDO, err error) {
	var (
		query  = "select id, hidden, iso2, default_name, name, country_code, prefixes, patterns, created_at, updated_at from help_country where hidden = 0 order by id"
		values []dataobject.HelpCountryDO
	)

	err = dao.db.QueryRowsPartial(ctx, &values, query)

	if err != nil {
		logx.WithContext(ctx).Errorf("queryx in SelectAll(_), error: %v", err)
		return
	}

	rList = values

	return
}
