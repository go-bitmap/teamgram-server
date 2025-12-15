/*
 * WARNING! All changes made in this file will be lost!
 * Created from 'scheme.tl' by 'mtprotoc'
 *
 * Copyright (c) 2024-present,  Teamgram Authors.
 *  All rights reserved.
 *
 * Author: teamgramio (teamgram.io@gmail.com)
 */

package service

import (
	"context"

	"github.com/teamgram/teamgram-server/app/service/biz/help/help"
	"github.com/teamgram/teamgram-server/app/service/biz/help/internal/core"
)

// HelpGetCountriesList
// help.getCountriesList = help.CountriesList;
func (s *Service) HelpGetCountriesList(ctx context.Context, request *help.TLHelpGetCountriesList) (*help.Help_CountriesList, error) {
	c := core.New(ctx, s.svcCtx)
	c.Logger.Debugf("help.getCountriesList - metadata: %s, request: %s", c.MD, request)

	r, err := c.HelpGetCountriesList(request)
	if err != nil {
		return nil, err
	}

	c.Logger.Debugf("help.getCountriesList - reply: %s", r)
	return r, err
}
