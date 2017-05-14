import React, { PropTypes } from 'react';
import { Link } from 'react-router';
import { FavoriteButton, TagList, Title, SubText, CompanyWrapper, CompanyItem } from 'components';
import { Wrapper, DateTime, JobWrapper, JobInfo, FavoriteButtonWrapper } from './styles';
import MdLocationCity from 'react-icons/lib/md/location-city';
import MdLocationOn from 'react-icons/lib/md/location-on';
import colors from 'styles/colors';

const propTypes = {
  id: PropTypes.number.isRequired,
  title: PropTypes.string.isRequired,
  area: PropTypes.string.isRequired,
  updatedAt: PropTypes.string.isRequired,
  techs: PropTypes.array.isRequired,
  favorited: PropTypes.bool,
  handleSwitchFavoriteStatus: PropTypes.func.isRequired
};

const iconStyle = {
  color: colors.leadSentenceColor,
  marginRight: 5
};

const JobItem = ({id, title, area, companyName, updatedAt, techs, index, favorited, submitting, handleSwitchFavoriteStatus}) =>{
  return (
    <Wrapper>
      <JobWrapper>
        <JobInfo>
          <Link to={`/jobs/${id}`} >
            <Title>{title}</Title>
            <CompanyWrapper>
              <CompanyItem>
                <MdLocationCity style={iconStyle} />
                <span>{companyName}</span>
              </CompanyItem>
              <CompanyItem>
                <MdLocationOn style={iconStyle}  />
                <span>{area}</span>
              </CompanyItem>
            </CompanyWrapper>
          </Link>
          <TagList tags={techs} />
        </JobInfo>
        {renderFavoriteButton(id, favorited, submitting, index, handleSwitchFavoriteStatus)}
      </JobWrapper>
      <DateTime>{updatedAt}</DateTime>
    </Wrapper>
  )
};

function renderFavoriteButton(id, favorited, submitting = false, index, fnc) {
  if (favorited === undefined) { return }
  return (
    <FavoriteButtonWrapper>
      <FavoriteButton
        jobId={id}
        favorited={favorited}
        submitting={submitting}
        index={index}
        handleSwitchFavoriteStatus={fnc}
      />
    </FavoriteButtonWrapper>
  );
}

JobItem.propTypes = propTypes;
export default JobItem;